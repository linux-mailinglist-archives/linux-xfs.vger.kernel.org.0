Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36B339AC18
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 22:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFCUyt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Jun 2021 16:54:49 -0400
Received: from sandeen.net ([63.231.237.45]:36198 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhFCUys (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 16:54:48 -0400
Received: from liberator.local (h15.159.16.98.static.ip.windstream.net [98.16.159.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CF4B84872FA;
        Thu,  3 Jun 2021 15:53:01 -0500 (CDT)
Subject: Re: [PATCH v3 2/2] xfsdump: intercept bind mount targets
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20201103023315.786103-2-hsiangkao@redhat.com>
 <20201103153328.889676-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d7d2773c-50d3-a0c5-c162-c6c31a67b8bb@sandeen.net>
Date:   Thu, 3 Jun 2021 15:53:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20201103153328.889676-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/3/20 9:33 AM, Gao Xiang wrote:
> It's a bit strange pointing at some non-root bind mount target and
> then actually dumping from the actual root dir instead.
> 
> Therefore, instead of searching for the root dir of the filesystem,
> just intercept all bind mount targets by checking whose ino # of
> ".." is itself with getdents.
> 
> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v2 (Eric):
>  - error out the case where the directory cannot be read;
>  - In any case, stop as soon as we have found "..";
>  - update the mountpoint error message and use i18n instead;

This looks fine, thank you. I wish I'd done it properly the first time,
I'm glad you saw the proper way to do it.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  dump/content.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/dump/content.c b/dump/content.c
> index c11d9b4..c248e74 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -511,6 +511,55 @@ static bool_t create_inv_session(
>  		ix_t subtreecnt,
>  		size_t strmix);
>  
> +static bool_t
> +check_rootdir(int fd,
> +	      xfs_ino_t ino)
> +{
> +	struct dirent	*gdp;
> +	size_t		gdsz;
> +	bool_t		found = BOOL_FALSE;
> +
> +	gdsz = sizeof(struct dirent) + NAME_MAX + 1;
> +	if (gdsz < GETDENTSBUF_SZ_MIN)
> +		gdsz = GETDENTSBUF_SZ_MIN;
> +	gdp = (struct dirent *)calloc(1, gdsz);
> +	assert(gdp);
> +
> +	while (1) {
> +		struct dirent *p;
> +		int nread;
> +
> +		nread = getdents_wrap(fd, (char *)gdp, gdsz);
> +		/*
> +		 * negative count indicates something very bad happened;
> +		 * try to gracefully end this dir.
> +		 */
> +		if (nread < 0) {
> +			mlog(MLOG_NORMAL | MLOG_WARNING,
> +_("unable to read dirents for directory ino %llu: %s\n"),
> +			      ino, strerror(errno));
> +			break;
> +		}
> +
> +		/* no more directory entries: break; */
> +		if (!nread)
> +			break;
> +
> +		for (p = gdp; nread > 0;
> +		     nread -= (int)p->d_reclen,
> +		     assert(nread >= 0),
> +		     p = (struct dirent *)((char *)p + p->d_reclen)) {
> +			if (!strcmp(p->d_name, "..")) {
> +				if (p->d_ino == ino)
> +					found = BOOL_TRUE;
> +				break;
> +			}
> +		}
> +	}
> +	free(gdp);
> +	return found;
> +}
> +
>  bool_t
>  content_init(int argc,
>  	      char *argv[],
> @@ -1393,6 +1442,14 @@ baseuuidbypass:
>  			      mntpnt);
>  			return BOOL_FALSE;
>  		}
> +
> +		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
> +			mlog(MLOG_ERROR,
> +_("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n"),
> +			     mntpnt);
> +			return BOOL_FALSE;
> +		}
> +
>  		sc_rootxfsstatp =
>  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>  		assert(sc_rootxfsstatp);
> 

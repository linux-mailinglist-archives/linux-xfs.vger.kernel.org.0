Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D5427B6FC
	for <lists+linux-xfs@lfdr.de>; Mon, 28 Sep 2020 23:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgI1V0c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Sep 2020 17:26:32 -0400
Received: from sandeen.net ([63.231.237.45]:41636 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1V0b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 17:26:31 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 59422616653;
        Mon, 28 Sep 2020 16:25:47 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013467762.2932378.12947505930529559840.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/4] libxfs: don't propagate RTINHERIT -> REALTIME when
 there is no rtdev
Message-ID: <e2ac3b92-1876-fddc-02e8-d464a8f94fd0@sandeen.net>
Date:   Mon, 28 Sep 2020 16:26:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <160013467762.2932378.12947505930529559840.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 8:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When creating a file inside a directory that has RTINHERIT set, only
> propagate the REALTIME flag to the file if the filesystem actually has a
> realtime volume configured.  Otherwise, we end up writing inodes that
> trip the verifiers.

The "else" means this is only for non-directories; we still propagate
the inherit flag to dirs even without an RT subdir, because ....  *shrug*
kernel lets you set it explicitly, and repair (now) doesn't care either?

Ok, seems reasonable.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/util.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 78519872e8e8..f1b4759728ec 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -224,9 +224,9 @@ xfs_inode_propagate_flags(
>  			ip->i_d.di_extsize = pip->i_d.di_extsize;
>  		}
>  	} else {
> -		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
> +		if ((pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
> +		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
>  			di_flags |= XFS_DIFLAG_REALTIME;
> -		}
>  		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
>  			di_flags |= XFS_DIFLAG_EXTSIZE;
>  			ip->i_d.di_extsize = pip->i_d.di_extsize;
> 

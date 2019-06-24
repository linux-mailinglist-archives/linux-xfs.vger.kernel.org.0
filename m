Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D6551991
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 19:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbfFXRaR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 13:30:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFXRaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:30:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHNjss171876;
        Mon, 24 Jun 2019 17:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=QQGRxzZgb+rsxdf2lZ2OLts30ANLX0LYrjouq2VCreQ=;
 b=jH5+IOo4UHfO8DkMPk0S4fhE/0sF84mKIlGDD9Rp5EiY23sX7kIk8KGg7gu+glEpAGdY
 yzvk3CkLstMdZaWgsuGMtYd0A02Fxhz2VkBKAwJQVUbqELIy3pUWBssbCkeEZ777MniM
 qvm6cqDChMBMwwLHt66k4wxGDi58HG4Eq06r3uEdRJ3y8fXVrLiycSl9GeMdo8Akhxxs
 wMMk6F031YGuQk5phl7tW8cMHDk+fowYW6Qc2N8wLPLrVK38Y+Q9svgBR3uRTnj9uE2Y
 DLoJwSUjmUWafrJYnYPgQoHnntroucn56LZWTiH0wXoL2j+BsioNcJvflQQuaPSQmEbe QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brsyrfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:29:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHRwek052539;
        Mon, 24 Jun 2019 17:29:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t99f3d6vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:29:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5OHTiTZ026200;
        Mon, 24 Jun 2019 17:29:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 10:29:44 -0700
Date:   Mon, 24 Jun 2019 10:29:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190624172943.GV5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134510851.2519.2387740442257250106.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134510851.2519.2387740442257250106.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so
> the options that have values like "10k" etc. still need to
> be converted by the fs.

/me wonders if that ought to be lifted to fs_parser.c, or is xfs the
only filesystem that has mount options with unit suffixes?

--D

> But the value comes to the fs as a string (not a substring_t
> type) so there's a need to change the conversion function to
> take a character string instead.
> 
> After switching to use the new mount-api match_kstrtoint()
> will no longer be called and will be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ab8145bf6fff..14c2a775786c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -166,13 +166,13 @@ static const struct fs_parameter_description xfs_fs_parameters = {
>  };
>  
>  STATIC int
> -suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +suffix_kstrtoint(const char *s, unsigned int base, int *res)
>  {
>  	int	last, shift_left_factor = 0, _res;
>  	char	*value;
>  	int	ret = 0;
>  
> -	value = match_strdup(s);
> +	value = kstrdup(s, GFP_KERNEL);
>  	if (!value)
>  		return -ENOMEM;
>  
> @@ -197,6 +197,20 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> +STATIC int
> +match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +{
> +	const char	*value;
> +	int ret;
> +
> +	value = match_strdup(s);
> +	if (!value)
> +		return -ENOMEM;
> +	ret = suffix_kstrtoint(value, base, res);
> +	kfree(value);
> +	return ret;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -268,7 +282,7 @@ xfs_parseargs(
>  				return -EINVAL;
>  			break;
>  		case Opt_logbsize:
> -			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
> +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
>  				return -EINVAL;
>  			break;
>  		case Opt_logdev:
> @@ -285,7 +299,7 @@ xfs_parseargs(
>  			break;
>  		case Opt_allocsize:
>  		case Opt_biosize:
> -			if (suffix_kstrtoint(args, 10, &iosize))
> +			if (match_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
>  			break;
> 

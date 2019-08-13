Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC46B8BB6A
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 16:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfHMOY3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Aug 2019 10:24:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48146 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfHMOY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 10:24:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DEOQ21075271;
        Tue, 13 Aug 2019 14:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kIkwBrUka4edbNsDr8XrXnzLNy94KFNesT+SURxBu5I=;
 b=D84AgWfXkADshCx7RKl7qKbZrI0zXn1TdXdaY6mlLzWSNzcv0gptqdVU96ttr4PfTOd1
 SBpMqDyl4qgsiIbbX9+bQpbDBK9usTBC4UXz85gPFKsQz4evsJhlGaGHU5FUuP0JPqin
 T12S5E455NSsAGexSIcMD79MFc3mKhBsD2bMlJpktfZ5uob7vg7xONwTqOenMGyWvDil
 txRnTpekSDsOSChhJFXOR29zpuXdN0xE6+ALZ+VWQscyJCK1lYm21I4E1kXXTN3B06lw
 OW9Pxbn6RtFrnybR+1WyerRaQsfqyj4/aF6QVBsX03nQ4tSnZQPHNuOzt+w7yna8g5Rl Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqejua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 14:24:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DEMa3D100364;
        Tue, 13 Aug 2019 14:24:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ubwcwuk2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 14:24:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DEOLWX027610;
        Tue, 13 Aug 2019 14:24:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 07:24:21 -0700
Date:   Tue, 13 Aug 2019 07:24:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: use cvtnum from libfrog
Message-ID: <20190813142414.GO7138@magnolia>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813051421.21137-2-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 03:14:19PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move the checks for zero block/sector size to the libfrog code
> and return -1LL as an invalid value instead. Catch the invalid
> value in mkfs and error out there instead of inside cvtnum.
> 
> Also rename the libfrog block/sector size variables so they don't
> shadow the mkfs global variables of the same name.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libfrog/convert.c | 12 +++++---
>  mkfs/xfs_mkfs.c   | 71 ++++-------------------------------------------
>  2 files changed, 14 insertions(+), 69 deletions(-)
> 
> diff --git a/libfrog/convert.c b/libfrog/convert.c
> index 8d4d4077b331..b5f3fc1238dd 100644
> --- a/libfrog/convert.c
> +++ b/libfrog/convert.c
> @@ -182,8 +182,8 @@ cvt_u16(
>  
>  long long
>  cvtnum(
> -	size_t		blocksize,
> -	size_t		sectorsize,
> +	size_t		blksize,
> +	size_t		sectsize,
>  	char		*s)
>  {
>  	long long	i;
> @@ -202,9 +202,13 @@ cvtnum(
>  	c = tolower(*sp);
>  	switch (c) {
>  	case 'b':
> -		return i * blocksize;
> +		if (!blksize)
> +			return -1LL;
> +		return i * blksize;
>  	case 's':
> -		return i * sectorsize;
> +		if (!sectsize)
> +			return -1LL;
> +		return i * sectsize;
>  	case 'k':
>  		return KILOBYTES(i);
>  	case 'm':
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0adaa65d19f8..04063ca5b2c7 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -942,69 +942,6 @@ unknown(
>  	usage();
>  }
>  
> -long long
> -cvtnum(
> -	unsigned int	blksize,
> -	unsigned int	sectsize,
> -	const char	*s)
> -{
> -	long long	i;
> -	char		*sp;
> -	int		c;
> -
> -	i = strtoll(s, &sp, 0);
> -	if (i == 0 && sp == s)
> -		return -1LL;
> -	if (*sp == '\0')
> -		return i;
> -
> -	if (sp[1] != '\0')
> -		return -1LL;
> -
> -	if (*sp == 'b') {
> -		if (!blksize) {
> -			fprintf(stderr,
> -_("Blocksize must be provided prior to using 'b' suffix.\n"));
> -			usage();
> -		} else {
> -			return i * blksize;
> -		}
> -	}
> -	if (*sp == 's') {
> -		if (!sectsize) {
> -			fprintf(stderr,
> -_("Sectorsize must be specified prior to using 's' suffix.\n"));

Hmm, so this message is replaced with "Not a valid value or illegal suffix"?

That's not anywhere near as helpful as the old message... maybe we
should have this set errno or something so that callers can distinguish
between "you sent garbled input" vs. "you need to set up
blocksize /sectsize"... ?

--D

> -			usage();
> -		} else {
> -			return i * sectsize;
> -		}
> -	}
> -
> -	c = tolower(*sp);
> -	switch (c) {
> -	case 'e':
> -		i *= 1024LL;
> -		/* fall through */
> -	case 'p':
> -		i *= 1024LL;
> -		/* fall through */
> -	case 't':
> -		i *= 1024LL;
> -		/* fall through */
> -	case 'g':
> -		i *= 1024LL;
> -		/* fall through */
> -	case 'm':
> -		i *= 1024LL;
> -		/* fall through */
> -	case 'k':
> -		return i * 1024LL;
> -	default:
> -		break;
> -	}
> -	return -1LL;
> -}
> -
>  static void
>  check_device_type(
>  	const char	*name,
> @@ -1347,9 +1284,13 @@ getnum(
>  	 * convert it ourselves to guarantee there is no trailing garbage in the
>  	 * number.
>  	 */
> -	if (sp->convert)
> +	if (sp->convert) {
>  		c = cvtnum(blocksize, sectorsize, str);
> -	else {
> +		if (c == -1LL) {
> +			illegal_option(str, opts, index,
> +				_("Not a valid value or illegal suffix"));
> +		}
> +	} else {
>  		char		*str_end;
>  
>  		c = strtoll(str, &str_end, 0);
> -- 
> 2.23.0.rc1
> 

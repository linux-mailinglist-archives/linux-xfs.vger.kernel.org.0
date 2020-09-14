Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAEA269537
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Sep 2020 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgINS6L (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Sep 2020 14:58:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49218 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgINS6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 14:58:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EIilKQ072111;
        Mon, 14 Sep 2020 18:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Qu58knI5mswK4BwmjwBARN74EoXMTEDeX7sK1HiwfHo=;
 b=lN9F+RLWYAW1MUFR47+B+ksAr4o8R7qqryW20N3ig5lWS1G2vu4NenbQAa6qeyHqq0a2
 PnsD8fkJhs74DHrHZ4GrgjDTVO4n4Lk76duCS7XG5/IwAg2ucMDbjgOgXulZCIEVA77H
 O79q5jnpokvsyAKgxPojNCdCW6PJCGOu8U+jaVGRfrTqejIVJtUmzStw6SgYeAhADLkA
 QKTAvcFPHWfjP7S3CCHBOVtYUz9DsZmhEzKUol41nUh6+iGluRZ794ww4cJYwWapCcoG
 Ms2xAYalMgRQYlXknC80MdFVGbOlSSBKD6Cg2xTgECcm290LvHQ+8m4+WS1F0f/qAA4z HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9m0fe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 18:58:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EIieUY125863;
        Mon, 14 Sep 2020 18:58:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33h88wgh2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 18:58:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08EIw5hg031786;
        Mon, 14 Sep 2020 18:58:05 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Sep 2020 18:58:05 +0000
Date:   Mon, 14 Sep 2020 11:58:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
Message-ID: <20200914185803.GY7955@magnolia>
References: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 01:26:01PM -0500, Eric Sandeen wrote:
> When a too-small device is created with stripe geometry, we hit an
> assert in align_ag_geometry():
> 
> # truncate --size=10444800 testfile
> # mkfs.xfs -dsu=65536,sw=1 testfile 
> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
> 
> This is because align_ag_geometry() finds that the size of the last
> (only) AG is too small, and attempts to trim it off.  Obviously 0
> AGs is invalid, and we hit the ASSERT.
> 
> Fix this by skipping the last-ag-trim if there is only one AG, and
> add a new test to validate_ag_geometry() which offers a very specific,
> clear warning if the device (in dblocks) is smaller than the minimum
> allowed AG size.
> 
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385..da8c5986 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1038,6 +1038,15 @@ validate_ag_geometry(
>  	uint64_t	agsize,
>  	uint64_t	agcount)
>  {
> +	/* Is this device simply too small? */
> +	if (dblocks < XFS_AG_MIN_BLOCKS(blocklog)) {
> +		fprintf(stderr,
> +	_("device (%lld blocks) too small, need at least %lld blocks\n"),
> +			(long long)dblocks,
> +			(long long)XFS_AG_MIN_BLOCKS(blocklog));
> +		usage();
> +	}
> +
>  	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>  		fprintf(stderr,
>  	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
> @@ -2827,11 +2836,12 @@ validate:
>  	 * and drop the blocks.
>  	 */
>  	if (cfg->dblocks % cfg->agsize != 0 &&
> +	     cfg->agcount > 1 &&
>  	     (cfg->dblocks % cfg->agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog))) {
> +printf("%d %d %d\n", cfg->dblocks, cfg->agsize, cfg->dblocks % cfg->agsize);

What is this?

(The rest of the logic looks fine)

--D

>  		ASSERT(!cli_opt_set(&dopts, D_AGCOUNT));
>  		cfg->dblocks = (xfs_rfsblock_t)((cfg->agcount - 1) * cfg->agsize);
>  		cfg->agcount--;
> -		ASSERT(cfg->agcount != 0);
>  	}
>  
>  	validate_ag_geometry(cfg->blocklog, cfg->dblocks,
> 

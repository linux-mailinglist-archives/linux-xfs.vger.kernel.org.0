Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6168C7AB52
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfG3OrY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 10:47:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfG3OrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 10:47:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UEhvdv003737;
        Tue, 30 Jul 2019 14:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=AsjOqCmlRauQGkDP20crpZ2FOBuL+BrsndvsqV7euQY=;
 b=l7GEkJwZapstlrE60GWodAhohl68ir4hXGBbvjZMVMKNGzvIl1dzomdzGZDofKyLvqZ4
 qsCwlJraPlL27ydNrPbSa2noQ87CmPJcE2lnjakWm73354kASV18bftYSrcmgn+Vr4OE
 sDRQGqDmk7KT+HJUXdaBbiOp/l+a77ynxGzUSx6zoGWRZsupC8oF8ocXTnEbNITsKDik
 Zr6AHewPvCNmsPwUn+Nu+I11/J8sowCscwfT0IS3fqMbLvX0dyZHnLu6hzpbc9DQyRu8
 lCBV3HpvDDnNNrYbq1o9q+Lzr9UhfINLt81t4g0jZ4qzVGI5EIoQVoyZj+YiI54teZyd SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u0ejpf01a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 14:47:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UEjjbR048080;
        Tue, 30 Jul 2019 14:47:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u0xv87yrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 14:47:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6UElBAa021594;
        Tue, 30 Jul 2019 14:47:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 07:47:11 -0700
Date:   Tue, 30 Jul 2019 07:47:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/rc: check 'chattr +/-x' on dax device.
Message-ID: <20190730144710.GR1561054@magnolia>
References: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 30, 2019 at 04:40:09PM +0800, Shiyang Ruan wrote:
> 'chattr +/-x' only works on a dax device.  When checking if the 'x'
> attribute is supported by XFS_IO_PROG:
>     _require_xfs_io_command "chattr" "x"    (called by xfs/260)
> it's better to do the check on a dax device mounted with dax option.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  common/rc | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e0b087c1..73ee5563 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2094,11 +2094,22 @@ _require_xfs_io_command()
>  		if [ -z "$param" ]; then
>  			param=s
>  		fi
> +
> +		# Attribute "x" should be tested on a dax device
> +		if [ "$param" == "x" ]; then
> +			_scratch_mount "-o dax"
> +			testfile=$SCRATCH_MNT/$$.xfs_io

NAK, the dax mount option is not intended to remain as a long-term
interface.

Also, "==" is a bashism (which probably is fine for fstests)

Also, there's no _require_scratch which means this can totally blow up
if the user doesn't specify a scratch device.

--D

> +		fi
> +
>  		# Test xfs_io chattr support AND
>  		# filesystem FS_IOC_FSSETXATTR support
>  		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
>  		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
>  		param_checked="+$param"
> +
> +		if [ "$param" == "x" ]; then
> +			_scratch_unmount
> +		fi
>  		;;
>  	"chproj")
>  		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
> -- 
> 2.17.0
> 
> 
> 

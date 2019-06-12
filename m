Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907A841CAA
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405978AbfFLGwQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:52:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56124 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403835AbfFLGwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:52:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6hWvm062405;
        Wed, 12 Jun 2019 06:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=rWOCiF/kVMzOKIhsLFnGeOhE4bBBnJyQndx49Pj13w0=;
 b=WE/SHYSJBhlztuqhZA5Aklp3Ve4xQAxer7wwMDrrbPLW4u0DTtGOq/ndhbjveeLdKuGr
 Pbm5WOaKTAf/YswESFvIxVS3otw9CaiqMGTC4jwmGDbdzzF44hrGlmSPn4p6EgejxCSw
 3Cq1QrQdTKJQyi6k9fNQiBJZ9Qkrhv6WZuWH2IuJfUpRTbdcsQKkTO4z2xoV0gVzp1IS
 g2idB0lMRUyc6cwe4Br7RsDwfnNNbqeZ/Db1vNbnnEHtpAIEcYVIbCpDl6yLdi84Wpxo
 FVLGvrlQhpFVhOUT2ASkXBZKB0iWg8VS17YNET6LY0TGAFxEapO78pLBqiX7DHRrsWmL 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2t02hesk26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:47:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6kCS2094630;
        Wed, 12 Jun 2019 06:47:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t0p9rq2an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:47:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6lCIu016873;
        Wed, 12 Jun 2019 06:47:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:47:12 -0700
Date:   Tue, 11 Jun 2019 23:47:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Alvin Zheng <Alvin@linux.alibaba.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        caspar <caspar@linux.alibaba.com>
Subject: Re: [PATCH xfsprogs manual] Inconsistency between the code and the
 manual page
Message-ID: <20190612064710.GY1871505@magnolia>
References: <a8dbaa7f-f89c-8a78-1fc6-3626f6b3f873@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8dbaa7f-f89c-8a78-1fc6-3626f6b3f873@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 01:20:46PM +0800, Alvin Zheng wrote:
> Hi,
> 
>     The manual page of mkfs.xfs (xfsprogs-5.0.0) says "When specifying 
> parameters in units of sectors or filesystem blocks, the -s option or the -b
> option first needs to be added to the command line.  Failure to specify the
> size of the units will result in illegal value errors when parameters are
> quantified in those units". However, I read the code and found that if the
> size of the block and sector is not specified, the default size (block: 4k,
> sector: 512B) will be used. Therefore, the following commands can work
> normally in xfsprogs-5.0.0.
> 
>      mkfs.xfs -n size=2b /dev/vdc
>      mkfs.xfs -d agsize=8192b /dev/vdc
> 
>     So I think the manual of mkfs.xfs should be updated as follows. Any
> ideas?

/me vaguely remembers some sort of discussion years ago around unease
that one can specify a block count without specifying the size of those
blocks...

...but to be honest, I don't really see why that would be a problem.
This seems fine to me, though I defer to Eric the Real Maintainer. :)

--D

> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..45d7a84 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -115,9 +115,7 @@ When specifying parameters in units of sectors or
> filesystem blocks, the
>  .B \-s
>  option or the
>  .B \-b
> -option first needs to be added to the command line.
> -Failure to specify the size of the units will result in illegal value
> errors
> -when parameters are quantified in those units.
> +option can be used to specify the size of the sector or block. If the size
> of the block or sector is not specified, the default size (block: 4KiB,
> sector: 512B) will be used.
>  .PP
>  Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
> @@ -136,10 +134,6 @@ The filesystem block size is specified with a
>  in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and
> the
>  maximum is 65536 (64 KiB).
>  .IP
> -To specify any options on the command line in units of filesystem blocks,
> this
> -option must be specified first so that the filesystem block size is
> -applied consistently to all options.
> -.IP
>  Although
>  .B mkfs.xfs
>  will accept any of these values and create a valid filesystem,
> @@ -894,10 +888,6 @@ is 512 bytes. The minimum value for sector size is
>  .I sector_size
>  must be a power of 2 size and cannot be made larger than the
>  filesystem block size.
> -.IP
> -To specify any options on the command line in units of sectors, this
> -option must be specified first so that the sector size is
> -applied consistently to all options.
>  .RE
>  .TP
>  .BI \-L " label"
> 
> 
>     Best regards,
> 
>     Alvin
> 

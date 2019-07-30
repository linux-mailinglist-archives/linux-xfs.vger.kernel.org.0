Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122847AB3D
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 16:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbfG3Ol4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 10:41:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbfG3Ol4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 10:41:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UEdnY6114253;
        Tue, 30 Jul 2019 14:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=yp8Sham1ZoyXa9T+rxy88V+9muzUa6yrOuy7KC/WPWk=;
 b=2n2RHO/hI+aTwSQU5Bn49kFO77Bn0tam6+jEzubFEU2YtVP1IyTTW4c9XruKFvkBtY4P
 BpTZ9/fg/osGIggT8P9J925PRdIsVhSRKMVan4E/2taAamt10I7YBVk+GkntlH3olsuf
 ROEVz2ao886koLHVOT7w3oN+DD7ZnNNG0ca/DOF+Ks6o7kMIfNh9JQ1rX5mMp1YcKZOA
 LT1W7K9tlPtS3jUTp5U4004cIYtegTeri8DK6hCvvUb7RE/uIZnHn5bkhaKq7s7pmXpU
 NEvYf/tR9mDqatkCwD/D/ATR0i9fhH/6sPekkjbMEip2Rf//CnW4ZqSg725Pn60aNHOR Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u0e1tq50k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 14:41:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UEbtMY026258;
        Tue, 30 Jul 2019 14:41:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u0xv87vav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 14:41:52 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6UEfqPM017230;
        Tue, 30 Jul 2019 14:41:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 07:41:52 -0700
Date:   Tue, 30 Jul 2019 07:41:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: design: Fix typo
Message-ID: <20190730144151.GQ1561054@magnolia>
References: <20190730123648.GA20126@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730123648.GA20126@localhost>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 30, 2019 at 01:36:48PM +0100, Sheriff Esseson wrote:
> Replace "possible" with "possibly" and improve the flow of the phrase.
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  design/XFS_Filesystem_Structure/overview.asciidoc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  mode change 100644 => 100755 design/XFS_Filesystem_Structure/overview.asciidoc
> 
> diff --git a/design/XFS_Filesystem_Structure/overview.asciidoc b/design/XFS_Filesystem_Structure/overview.asciidoc
> old mode 100644
> new mode 100755
> index d15b50a..7628a7d
> --- a/design/XFS_Filesystem_Structure/overview.asciidoc
> +++ b/design/XFS_Filesystem_Structure/overview.asciidoc
> @@ -28,7 +28,7 @@ record.  Both forks associate a logical offset with an extent of physical
>  blocks, which makes sparse files and directories possible.  Directory entries
>  and extended attributes are contained inside a second-level data structure
>  within the blocks that are mapped by the forks.  This structure consists of
> -variable-length directory or attribute records and possible a second B+tree to
> +variable-length directory or attribute records and, possibly, a second B+tree to
>  index these records.
>  
>  XFS employs a journalling log in which metadata changes are collected so that
> -- 
> 2.22.0
> 

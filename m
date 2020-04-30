Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498721C0078
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Apr 2020 17:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgD3PhN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Apr 2020 11:37:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgD3PhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 11:37:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UFWpkd005830;
        Thu, 30 Apr 2020 15:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=osfPOqHK5D6WqpabbtiqKb7pjbt0jfHbjsyT0wbYlSM=;
 b=QOd13aDNRWT4euhKsgsnr6VX7haKfMKUNrB+XeL7Zp3ncS9naXP+UuRGLSvrLl4LL3Lq
 uetjiQF8OGwcXgg7OHpzx0XjIuRIz/j3IlTDBHiOXRBMI37HS1b4mW8qFelHwrpRZoG0
 kOTRvUBgAFXle4Tmz8bblyLBMmf107JjEhufEmd4FHB2HC/Rz/PNFNfOYfvlcpX7I7Kp
 X9RZO+Ob81rAjbFkIKsyvch73FHmP2e03vyyPgkMJADdqP1liQDM3wXKnrZ/StwKC2f4
 XWiJ63CFJ1sVAdYFvPKdko/SgkvevdU5eUhpWF/Tq974P4UpXeoKSb02dlL0QS0rDaHE 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucgc69q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 15:37:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UFWIbr135658;
        Thu, 30 Apr 2020 15:35:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30qtg17m36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 15:35:08 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UFZ4qH025136;
        Thu, 30 Apr 2020 15:35:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 08:35:04 -0700
Date:   Thu, 30 Apr 2020 08:35:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: deferred operations cleanup
Message-ID: <20200430153503.GZ6742@magnolia>
References: <20200429150511.2191150-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=937 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=991 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:00PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up the deferred operations code by merging a few
> methods, and using more type safe types.

The series looks pretty straightforward to me, so for all of it:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

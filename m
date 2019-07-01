Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEDE5C05B
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 17:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGAPgL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 11:36:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfGAPgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 11:36:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61FXkbN026995;
        Mon, 1 Jul 2019 15:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=l/FaIxYkXoLqGjThq0mMhkAgGrKUtGga8kNE6smlY94=;
 b=g87chmR+XCJB1wcBrTux2h4joTWamxngZmbJr8WiUZGIMSomAix3xysqYyb09eldUlLZ
 PyKLvIJzQPURMoG1zOL6KCSO1YGHjMe/D6z0FXNLooeR6UAsjgaH4vDAvFmp5SoY6vYI
 e16q+P9LD1TjUoMEMObWlR+6rDiuU3kkA5utL/kEPhxEnwzdxs7s7CFoNQWbyTotkERo
 DlA0FbJwOt8WtroQVQBxrPaKymtCkxHs5Kd2WcadGuIVGNhKsMreZU45FfUPFvofrQ1h
 8twOTfPyNP8AvMRqIGlZuJgWjoz7w+t+udq+PclGJcZ66ZsXdz8sVZ9smSiWb7s3VVRm Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbeeey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 15:36:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61FWV1m088326;
        Mon, 1 Jul 2019 15:36:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebak8a09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 15:36:00 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61FZse4012458;
        Mon, 1 Jul 2019 15:35:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 08:35:54 -0700
Date:   Mon, 1 Jul 2019 08:35:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-xfs@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Adding some trees to linux-next?
Message-ID: <20190701153552.GJ1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701110603.5abcbb2c@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Stephen,

Could you add my iomap-for-next and vfs-for-next branches to linux-next,
please?  They can be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#iomap-for-next
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#vfs-for-next

I've decided that trying to munge all that through the xfs for-next
branch is too much insanity and splitting them up will help me prevent
my head from falling off.

--Darrick

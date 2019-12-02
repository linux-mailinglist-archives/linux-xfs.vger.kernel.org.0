Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3873910EE7A
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Dec 2019 18:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfLBRgE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 2 Dec 2019 12:36:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfLBRgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:36:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZLCE035963;
        Mon, 2 Dec 2019 17:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=UfC23OqQM0+If5JyI0cq+or369mpVTc1SIfF3aU483U=;
 b=HsBWHGBgAv90DsUGuFqbpJ8WLL59V+HZO710V8d8NBCfiF6WDhay8pi+ruc0lej/H+X8
 mMQcQkKIAzjCJGx6Etc1PDGhcsbUcs7nclUC4bASbAo2yskEzOMhCRGviG6ugzH7eiqV
 WJkTNLvawkEbcdVyVDsyyC5rYAzR1mPJPCHwLkPF4VOoQEzLgRXIOBwDHtVHVlkwWTjb
 xTsVLy6yE0jJrw5BwCwYBc3l0Bh7gCbvERei/L9g6dNXLzmf0yKLu+4WotNGxe813dtC
 awmonteXucPYdk4WgmcmYyV50u+IcxrywdJQoap7S4ZXEeUlwBeLNh99vQyUc3iizPiM MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wkh2r1hg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYQGf169663;
        Mon, 2 Dec 2019 17:36:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wm1xp7204-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2HZxlT010542;
        Mon, 2 Dec 2019 17:36:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:35:59 -0800
Subject: [PATCH RFC 0/4] xfs_repair: do not trash valid root dirs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Mon, 02 Dec 2019 09:35:58 -0800
Message-ID: <157530815855.126767.7523979488668040754.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=924
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=985 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Alex Lyakas observed that xfs_repair can accidentally trash the root
directory on a filesystem.  Specifically, if one formats a V4 filesystem
without sparse inodes but with sunit/swidth set and then mounts that
filesystem with a different sunit/swidth, the kernel will update the
values in the superblock.  This causes xfs_repair's sb_rootino
estimation to differ from the actual root directory, and it discards the
actual root directory even though there's nothing wrong with it.

Therefore, hoist the logic that computes the root inode location into
libxfs so that the kernel will avoid the sb update if the proposed
sunit/swidth changes would alter the sb_rootino estimation; and then
teach xfs_repair to retain the root directory even if the estimation
doesn't add up, as long as sb_rootino points to a directory whose '..'
entry points to itself.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

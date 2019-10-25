Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06FAE42D7
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 07:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392741AbfJYFRT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 01:17:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392740AbfJYFRS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:17:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DlkI102634
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=NHzWcVmujDnj/Iexy6w11q/Ea0Gkz50BiF8y610OhQk=;
 b=lz36QhdWOQl4a9KwxhQHn+ncH1eeMILiLHPc9UaknOl5xNyxBvnn0Was6oFp3abrJJwe
 AzD0PHW3j0pHWH6IoCsZWqxN2Fovzo9gj3joLQ+dJg3J6TZiFXV7Tssvsp1W4LCF2vZw
 vil+kUmPPqMxkU/s+jWpkLul6b/bj+j/2ZYPUg/dKbPQYpxRRwQYgcwX+zBC25KMPXzd
 Ya9EtXUe6ErWkS3avaTzagL/9wFdSU4BCw5aegiNafcxyTC6ur9rSR/wMox86sxg6tL5
 1gpb+Qxriii7WWAsnPEQejB7mEvSY69knQohMTK0UyhX0lAcLJL8EssoQKShe91OJlFE Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4r7yty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:17:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DiEG073868
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vtsk6ufdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:17 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P5FGPQ002399
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:15:16 -0700
Subject: [PATCH 0/2] xfs: refactor open-coded bmbt walks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 22:15:15 -0700
Message-ID: <157198051549.2873576.10430329078588571923.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These two patches refactor a couple of bmbt functions to use generic
btree code for counting blocks and reading extents into the incore tree,
instead of open-coding that.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-refactor

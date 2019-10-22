Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C6E0BB5
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Oct 2019 20:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfJVSrJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Oct 2019 14:47:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiW19109673;
        Tue, 22 Oct 2019 18:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ZVdE5pLW0suPzZXvPhoG96lwomuMX7bXc5WRrSdUGMs=;
 b=sPj6tuUNY+lM+pkGmgxrKGVJ8isYbEbV5tnn+wQF9zrMKQOm1sMokrZJUSSZujSBt1Xk
 IfXzmSZiQmPJB964lNqeOCTTgKfTzXYnl/bRUGzJjTidCWjQxEHzm6FiIkD4kYQeJpJv
 Jl5PYvo2a5Rp2wUmLTZTrh2oJ3CV/rlnc5YFAVSGVvxjyk1rDsCvRZtDsfuIHHmVW6mM
 lQlGk42jQ0Awf+dMZ3grb8+UJsCHlYGijJcQls4JRFtfhfeTVL9HxtFjy5C4+hDbz0Eq
 TvH6900HdDAG+e/rN1mGRkO2XubhgmZSKre2KqcqR3W6REJag/datrkQj6TD37ImMya+ YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtgukn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhOfs125200;
        Tue, 22 Oct 2019 18:47:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vsx239nmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIl5N4028671;
        Tue, 22 Oct 2019 18:47:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:05 -0700
Subject: [PATCH 0/9] xfs_scrub: fix IO error reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:04 -0700
Message-ID: <157177002473.1459098.11320398367215468164.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The scrub media error reporting could use some improvements -- first,
scrub can calculate the exact offset of media errors in file mappings,
so we should report more precise offsets.  Second, we only need to scan
the rmap once after assembling the io error bitmap to look for destroyed
metadata (instead of once per error!).  Third, we can filter out
unwritten and attr/cow fork extents from what we report since sector
remapping takes care of unwritten/cow extents and attr media errors
should be detected by phase 3.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-error-reporting

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-media-error-reporting

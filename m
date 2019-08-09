Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE2D188527
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfHIVlW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:41:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHIVlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:41:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYWfI092777
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=9l6tjZ6bT6pwoXjcvusR96zl0gYXoAEjT4t7e8VkoUo=;
 b=h0oetskKQtLgPCdMiRReO4teBBzwtDVMQvWk25Dsnp8BDqqqPkOaEdqqcfm7qXlWo0KV
 ypCjU1zmLpmp5NaLogiX1blx3cSUBsW2hlpCLmeUHVGKeu6ZlmX87sYLZpIOnuyQMkX2
 FrP3leCFmpV3WqdyYV412gyWhsI7EK4Vr05aazRORFm/bZRO4OwZsOkS+qlbUIgBna+M
 XH+9P1QA6HofHI4WJNAwX0JENQHIxNQ9OcOPw6ijtAg1KoLHIm4FYPJAd9RA/RsF5WyN
 W2u2o5VuOoEEr7AGk5SeIStE6WnUdf4o/HuocIEFsL8YdtP8ylEyNd8FiHUWb6+jpIG1 mA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=9l6tjZ6bT6pwoXjcvusR96zl0gYXoAEjT4t7e8VkoUo=;
 b=dMMd0SVTHjQq/Ql10Rh2HOkmHjVfuLcqPpD+l0/sJlvL/MJ9IRcVycEOTjN0k1FRKLhf
 h5wvKk75ljyd6BydqRbEL9pEfd1RNb53wEnLrvpvWbP7ca/asgyB6kvcj+tXt2jgF+VV
 VbF913sh3ejGoYGoz4L3deC3fM++IfzdO3rxg7UFcMFztgN59qJpXIlI0x9NdFRAeKlg
 CBNPO3diTX/s8v5VRl2JFdwJW2YWcleA/d3wQk1kgW2X5L2/tduBcIKMh4/H7jer6rhG
 CHZk2L+Gl3w/MCLNiPDFe4SEG2+vS5W0Gu+V4vgWflM++kixtvStH0LfhLEF3s+hV5aF ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u8hasj9gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:41:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcQrc110154
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u90t815dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcY60002297
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:34 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:34 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 0/1] Add delayed attributes test
Date:   Fri,  9 Aug 2019 14:38:28 -0700
Message-Id: <20190809213829.383-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=673
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=735 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a quick test to excersize the delayed attribute
error inject and log replay.

Allison Collins (1):
  xfstests: Add Delayed Attribute test

 tests/xfs/512     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  18 ++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 121 insertions(+)
 create mode 100644 tests/xfs/512
 create mode 100644 tests/xfs/512.out

-- 
2.7.4


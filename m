Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6708D12DC7A
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jan 2020 02:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABBX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Dec 2019 20:01:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48762 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgAABBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:01:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00111Mhh105565
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=EwjiA4uyPqHGs4NIGKo4zRBXCkrPnaCa6R1Jbp2mhA4=;
 b=qQ1vycxaQfPSuoub6QKMDfHirHhuAfxQbeczJc3HUtNtpk4ybVRy7KYSly8a+QvBIJj1
 YK1q1KxUmS31GGrFw5PUmTqPA0PN43/PRD5h5pwYJsvdhnUxWIMnO/xs5aRmEn3RG9cj
 EU5JtSObDdT8wXldvh69+DNKzizvmuHHBJNplXdEZ680yLIFbzGyVXryoh0aeiePN2LO
 CF9Fj8m8+2DjjKdSj3vigoZ9Ka0tm/KaLd9GTjSoovPr6pS9JOzgzr4tnM5CWXlXd903
 JhmqushInZ6dNpsbbBIWW3LNJCbfAD6x6IJo26Be5Lr2FQ9SHAbgINg6PlHY7ywaVpcE Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk24c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:01:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wwLW190696
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8gueda3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:01:20 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00111KWK023173
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:20 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:01:20 -0800
Subject: [PATCH v2 0/3] xfs: fix online repair block reaping
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:01:18 -0800
Message-ID: <157784047838.1357430.18292934559846279176.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These patches fix a few problems that I noticed in the code that deals
with old btree blocks after a successful repair. First, we clarify how
the reaping function works w.r.t. bitmap lifetimes.  Next we fix a bug
where we could incorrectly invalidate old btree blocks if they were
crosslinked.  Finally, we convert the reap function to use EFIs so that
we can delete blocks without overloading a transaction.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-reap-fixes

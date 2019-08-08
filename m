Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D85864AA
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 16:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfHHOqy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Aug 2019 10:46:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48256 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730678AbfHHOqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 10:46:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78EhcPM083951
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=v8UFteJydvPEqjmvL+o7RFcK/592LyKjKWo5wPD9XHs=;
 b=VkVLqChAhu8b3JMgrfkpueRhYNJIdvRA2c/Dr/PkoFWh1UwN8+1pQ7rTFBejl/sMlBxU
 b2q3L93uFZVrBlYn2+IKQFo2TdRzPj0I0LLjfgFaJOTbBEgBdu6Sl4zf7U7P0ObZe/PB
 V372yImlgDR+njtUrelfRc5vgXg4KLNcrpVDMWdQprI0gebUQuih5KD2Svw0xZJp7yNZ
 Da2EIaE4kyHSpRihmNN30cgbNrcmPzzTli1cojb2j/IjxcAZMu6o/UrabVxu6xXubF2L
 DBazC7jArKRtfP1A/sxxSKjEiwn18x5kjoxU8R+NzBwbLpcqpHvdU5+XZYzEpM70HaT7 Nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=v8UFteJydvPEqjmvL+o7RFcK/592LyKjKWo5wPD9XHs=;
 b=ZRJVIq96dT4HW3QdTsWPP4EZa3ghqB5HQCNO6EJnCyYEiAyKo5iO0FUpNA3Jwd1rxxFy
 U2H4efFGg61woBv7muc856JekBEGchW1KTEIeT7dHl7gB4Dmah+NyUaFzhM5MgnYIZeb
 SY1sckAAZklmLwRW/wkWtwJbxo6h5Whb6vRHP2s0IVcv/wybjw9lOwhoMaWYzGJYiqAS
 Bd+X133bOy0luqOgdHhMNUDuviE57CXBlCr6OgxFHAdQQT6PEbuM+VA/0tryMg0802BY
 xpXY2DInVYO00I0wJnDr8ybA7A4hCznnwJeP3SKkxEFJ6gW+GMpkq4FsGi5i2gCZqf6b OQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u8hgp1q78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:46:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Egw7v150782
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:46:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u76698kc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:46:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x78Ekpp6018332
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:46:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Aug 2019 07:46:51 -0700
Subject: [PATCH 0/3] xfs: various fixes for 5.3
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 08 Aug 2019 07:46:50 -0700
Message-ID: <156527561023.1960675.17007470833732765300.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=858
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=911 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are assorted fixes for 5.3.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-5.3-fixes

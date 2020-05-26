Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F1019FD88
	for <lists+linux-xfs@lfdr.de>; Mon,  6 Apr 2020 20:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgDFSwc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 Apr 2020 14:52:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59332 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgDFSwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 14:52:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IhDCb145117;
        Mon, 6 Apr 2020 18:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=TD/9simyEALXsSJvGnx2Ei1KJuU7TaeLYpo9vfHGhcU=;
 b=J6LzikTe6gq6ucY6KpBLEbgkIBO96igAvpBFheruI5vvIU795eS+K1+OOwtzNfiMy5Lg
 eKIn7J3JUI22Al5jQXnDrLjo65SrbSjfFFwx/EP8UHnktR4cQUBMQsAIe/M4sCyERRSO
 ueHgiDx/NsAdCcXJm11xXOfC5MKM+Od1VrixaqsryFFBargEjet3KCWpN1meRmj8+iJn
 X27cG2Q+lXnK6OLTH+CwOR3nLE/DMW7MwNnQ5BP6SGKAowlPHBkM7pkXkiyY1+PAABvG
 KPD1dvo2I92vI/GxMq0A3ciFr8npOv+QIQkmMqSJ22e4x/h7rLD8fPNGKjiD7OB1tLG/ /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 306jvn0nc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IfQt1040806;
        Mon, 6 Apr 2020 18:52:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30741bcu17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036IqP9o028814;
        Mon, 6 Apr 2020 18:52:26 GMT
Received: from localhost (/10.159.131.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:52:24 -0700
Subject: [PATCH 0/5] xfsprogs: rollup of various fixes for 5.6
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 06 Apr 2020 11:52:23 -0700
Message-ID: <158619914362.469742.7048317858423621957.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=872
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=949 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains fixes for a handful of errors that Coverity found,
minor reworks for API shifts, and fix for a typecasting problem in scrub.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.6-fixes

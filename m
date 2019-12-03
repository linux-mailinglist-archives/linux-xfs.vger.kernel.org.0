Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1F610F531
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Dec 2019 03:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfLCCuK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 2 Dec 2019 21:50:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfLCCru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 21:47:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32iGka093529;
        Tue, 3 Dec 2019 02:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=KcxEo85gQ/YKqMm2/EaG13iS81eAVdh5wEfYOTh4KW0=;
 b=kg7Yzmml+Rko8/7U7jgjNlbhFMsqZapx2utwMGuZ+zy6jR6DTr03x8a9hIUPIRmssY+P
 PV0kNXFd03bG7SgJY114sBqmXvaxYVK3Ucs+JADYoEECaLAzDNQTk35qaJdzE5wOaP4S
 wzADDHuCuM0I1Dfp6tr77HT+Tm1RSNvlGfRqN1PMTPUgD/D7QoHqDdV6G0YwtA5Al5rO
 Kb5Lw7SunpmQ30EmAr1Nx2ZDcnTe2uODhmN7h0/eMvrMAlQXBVBAEYBoFbFPCT9nC/p+
 a6L1WsPc4VILGAaKeyV8L1WXVNZd+ak+fQEasR5x2KnZNY0WSj5ZphHxlR1FryVwxDi/ ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wkfuu4du4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:47:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32iCx6166195;
        Tue, 3 Dec 2019 02:47:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wn8k1hb8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:47:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB32liE2025365;
        Tue, 3 Dec 2019 02:47:45 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 18:47:43 -0800
Subject: [PATCH v2 0/2] xfs_admin: unify online/offline fs label setting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 02 Dec 2019 18:47:42 -0800
Message-ID: <157534126287.396264.13869948892885966217.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=634
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=716 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are two fixes for the xfs_admin script.  The first enables callers
to pass an external log device, because xfs_db requires that to work on
filesystems that do not have an internal log.

The second patch enables xfs_admin to call xfs_io, which is then used to
pass label get and set commands (-l and -L) to the kernel (via xfs_io) if
the filesystem is mounted.

v2: Improve the manpage updates.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

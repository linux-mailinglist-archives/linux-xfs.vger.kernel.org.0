Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCD6F25B4
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 04:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbfKGDCW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Nov 2019 22:02:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44274 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732732AbfKGDCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x6Uj049384
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=IjEAmKlMGFuMeXKqymVgtNjQsj+j2MQ/o9xGyEqfBkA=;
 b=GlWrW8hi+h5SNfk/mO+K6x6IBmOL+WMbguDe0ipsZYqbR/FCIG1QJl8AJjC+nNwF5oV3
 yjXKrlE/TwgWf7j/ihQev1kMHXkWigMpCxWrZgd/4oYSD4ENQyqcjFh5SSYE/b+dM9Lg
 Duv94I3ihAHGQApDiPn0PmX0vwibZuGxfzXtepF1clch1P6AEXeUevD4B1vwKZurlrO4
 QjDB8H1i78HUgsQz2T99O8ncu0DlobcdMq83CLwPu/OnBaxUSHEJOR5N3Ts1KNVae19l
 jT40I6NPuIqLrns+UYuo+EPt3S5C+0ZJQCX3mInu6pgGrDE0la/6epPMdcf9nCFx3wJA Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w130bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wii8168676
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wds5c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA732K13028956
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:19 -0800
Subject: [PATCH 0/6] xfs: various coverity fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:02:18 -0800
Message-ID: <157309573874.46520.18107298984141751739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=668
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=746 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In a previous series we performed a lot of cleanups to the metadata
corruption detection code in XFS.  Now add the ability to report these
problems to the health tracking system so that administrators can gather
reports on live filesystems, and (in the future) to enable more targeted
scanning of metadata.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

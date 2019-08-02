Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8867E743
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Aug 2019 02:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403867AbfHBArC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 20:47:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388445AbfHBArC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 20:47:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x720iwc0039038
        for <linux-xfs@vger.kernel.org>; Fri, 2 Aug 2019 00:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=B8ICzaZ0+RF0eI+XPHuTGoCyL5K/xdVZPJNgfdMqu60=;
 b=tdKFbBFTUfUcltEru5F8DtMajrvG55UA/TqNvKe1xl2euqUd8P+7mczPM8RQHucFAL5W
 pvqa/+n2OUnOwUtrMQRCv82JjE3+cosEMo9cVHbVRT8mvWc0qxY0Cm30VLgkWDTz8Vtl
 ZGWK/zeQi4x2GA2WrehgQNI50Y2/UHX9s9WrgA0VJnXV73g+3FHum5pAAIyHk0rSlIGr
 fHdUe/no/EiLcq/IBcgjmieQjyuiNcya0ZvsPBtM3EOpi8S33/V+SLy9n878WlMYLH7S
 dHNefbiX+5kfcXKykstVM2uHTLBriCK4gVXoTEyZ807+wNuor7iLTEo3BNo9yeWj6ejZ uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u0e1u7398-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 00:47:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x720hUfp140800
        for <linux-xfs@vger.kernel.org>; Fri, 2 Aug 2019 00:47:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u49htsjt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 00:46:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x720kwWH001846
        for <linux-xfs@vger.kernel.org>; Fri, 2 Aug 2019 00:46:59 GMT
Received: from localhost (/10.145.178.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 17:46:58 -0700
Date:   Thu, 1 Aug 2019 17:46:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: master updated to f7a3675
Message-ID: <20190802004657.GF7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908020003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908020003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the master branch is commit:

f7a3675 xfs: design: Fix typo

New Commits:

Sheriff Esseson (1):
      [f7a3675] xfs: design: Fix typo


Code Diffstat:

 design/XFS_Filesystem_Structure/overview.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 design/XFS_Filesystem_Structure/overview.asciidoc

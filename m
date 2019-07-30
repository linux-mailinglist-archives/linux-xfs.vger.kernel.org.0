Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00F579D92
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 02:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfG3AtW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jul 2019 20:49:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfG3AtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 20:49:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6U0nJFk001818;
        Tue, 30 Jul 2019 00:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=blr9tNeZN2ggMtRR68XRHu4jy3hwjeRuEEvIJpfh8tg=;
 b=eate+SahHg3fL+DHyDc8ZDf1lD4zP0mptP7OmI+fCe7hCeNGlU4STcb5C7rNFxr+8MTr
 +9EVHTnTGYFDLMMTRaozPAIsZouBaQwshCVAeocEFoOPHACX+K2pSmybpHeyfH6seCWR
 fn/XAQW/Vpu7kky+959wLHiMNcO5D5kTVaG4bZjcQkauGYsWsuNP7I+sgB2wlVejA04v
 nX06qNG7XwvMKngerHdjU27z6uWVjuOKiP4CIhXpVmiXenW9THoDLdonzBZWsNZvlIPU
 +MWAtWZui5drd25RlfTE5BzdTP7unD4Sb2qFwwEGWBBTaXvDpsvl+kcHryFGNBuaXO6/ 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u0f8qttju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 00:49:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6U0leJu164672;
        Tue, 30 Jul 2019 00:49:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u0dxqm2wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 00:49:19 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6U0nIZx026141;
        Tue, 30 Jul 2019 00:49:18 GMT
Received: from localhost (/10.159.132.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jul 2019 17:49:17 -0700
Date:   Mon, 29 Jul 2019 17:49:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/4] xfs: fixes and new tests for bulkstat v5
Message-ID: <20190730004917.GB2345316@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <20190728112635.GN7943@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728112635.GN7943@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9333 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9333 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 28, 2019 at 07:26:35PM +0800, Eryu Guan wrote:
> Hi XFS folks,
> 
> On Tue, Jul 23, 2019 at 09:13:14PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Fix some problems introduced by the creation of the V5 bulkstat ioctl,
> > and then add some new tests to make sure the new libxfrog bulkstat
> > wrappers work fine with both the new v5 ioctl and emulating it with the
> > old v1 ioctl.
> 
> I may need some help on reviewing this patchset, especially the new
> bulkstat tests :) Thanks in advance!

Let me know if you have any questions. :)

> But I'd suggest split the last patch into two patches, one introduces &
> uses the new helper, the other one adds new tests. Also, it misses a new
> entry in .gitignore file.

Oops, will fix.

--D

> Thanks,
> Eryu
> 
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bulkstat-v5
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bulkstat-v5

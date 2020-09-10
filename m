Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDFB2650F8
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Sep 2020 22:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIJUgj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Sep 2020 16:36:39 -0400
Received: from dedicated-afm47.rev.nazwa.pl ([77.55.142.47]:27514 "EHLO
        dedicated-afm47.rev.nazwa.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbgIJUck (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 16:32:40 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2020 16:32:39 EDT
X-Virus-Scanned: by amavisd-new using ClamAV (23)
X-Spam-Flag: NO
X-Spam-Score: -1
X-Spam-Level: 
X-Spam-Status: No, score=-1 tagged_above=-10 tests=[ALL_TRUSTED=-1]
        autolearn=disabled
Received: from poczta.sysgroup.pl (dedicated-aib150.rev.nazwa.pl [77.55.209.150])
        by server192927.nazwa.pl (Postfix) with ESMTP id 3A1261C3D5F
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 22:26:40 +0200 (CEST)
MIME-Version: 1.0
Date:   Thu, 10 Sep 2020 22:26:40 +0200
From:   "LinuxAdmin.pl - administracja serwerami Linux" <info@linuxadmin.pl>
To:     linux-xfs@vger.kernel.org
Subject: xfs_info: no info about XFS version?
Reply-To: info@linuxadmin.pl
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <01aa416f70d0d780b337fb77756a88a8@linuxadmin.pl>
X-Sender: info@linuxadmin.pl
Organization: LinuxAdmin.pl - administracja serwerami Linux
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hello,

why there is no info about XFS version on xfs_info?

# LANG=en_US.UTF-8 xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=4, agsize=6553408 
blks
          =                       sectsz=512   attr=2, projid32bit=0
          =                       crc=0        finobt=0, sparse=0, 
rmapbt=0
          =                       reflink=0
data     =                       bsize=4096   blocks=26213632, 
imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=0
log      =internal log           bsize=4096   blocks=12799, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

-- 
LinuxAdmin.pl - administracja serwerami Linux
Wojciech Błaszkowski
+48 600 197 207

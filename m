Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D334A18BA
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 13:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfH2LfM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 07:35:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50664 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbfH2LfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 07:35:12 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9FBAF43E631
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 21:35:09 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ihn-0003V9-Re
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 21:35:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ihn-0007AI-NZ
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 21:35:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3 v3] xfs: allocate xattr buffer on demand
Date:   Thu, 29 Aug 2019 21:35:00 +1000
Message-Id: <20190829113505.27223-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=FmdZ9Uzk2mMA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=zlCzXOuynseuPHxUj78A:9 a=6RyHdP9wf0s6W1bbVaoE2bQoMl4=:19
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Updated series to address Christophs revierw comments. V2 can be
found here:

https://lore.kernel.org/linux-xfs/20190828042350.6062-1-david@fromorbit.com/T/#t

v3:
- fixed typoes and stray mods in patch 1
- split patch two into an indent removal patch and a consolidation
  patch.
- split patch three in a consolidation pathc and a patch to add
  allocation on demand.
- various other minor cleanups.



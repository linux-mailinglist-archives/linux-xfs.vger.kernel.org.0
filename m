Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A09C70B
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 03:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfHZBkO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 25 Aug 2019 21:40:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43987 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfHZBkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Aug 2019 21:40:14 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 183DC36216F
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 11:40:12 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i23zO-0000rS-DY
        for linux-xfs@vger.kernel.org; Mon, 26 Aug 2019 11:40:10 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i23zO-0002uw-9H
        for linux-xfs@vger.kernel.org; Mon, 26 Aug 2019 11:40:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: use aligned buffers for IO
Date:   Mon, 26 Aug 2019 11:40:04 +1000
Message-Id: <20190826014007.10877-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=FmdZ9Uzk2mMA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=k-KD1Of0fgKsNKAikowA:9 a=6RyHdP9wf0s6W1bbVaoE2bQoMl4=:19
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is an updated version of the patchset originally posted here:

https://lore.kernel.org/linux-xfs/20190821083820.11725-1-david@fromorbit.com/T/#t

It intends to avoid th eproblems of IO being silently corrupted
by drivers when kernel memory debugging options are turned on due
to changes in heap allocated object alignment. Full description is
in the link above.

Changes in V2
- dropped xfs_add_bio_page() validation wrapper. Contentious,
  Christoph will look to adding it into the generic block layer
  code.
- added xfs_buftarg_dma_alignment() to grab the alignment from the
  current device we are allocating a buffer for.
- feed the correct alignment for the underlying device into
  kmem_alloc_io() to minimise the occurrence of failed alignment for
  devices that support fine-grained alignment.
- kmem_alloc_io() supports alignment up to page size and will warn if
  any alignment greater than a page is requested. Devices that
  require larger than page alignment should not exist.

Cheers,

Dave.



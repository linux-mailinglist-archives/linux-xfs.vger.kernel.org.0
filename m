Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595CB3922EC
	for <lists+linux-xfs@lfdr.de>; Thu, 27 May 2021 00:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhEZWtE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 May 2021 18:49:04 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48716 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234672AbhEZWtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:03 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8291C1044751;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8S-Iy; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fA6-B2; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 00/10] xfs: buffer bulk page allocation and cleanups
Date:   Thu, 27 May 2021 08:47:12 +1000
Message-Id: <20210526224722.1111377-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=xYOW8HJDSiiKkmNxUIAA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a rework of my original patch posted here:

https://lore.kernel.org/linux-xfs/20210519010733.449999-1-david@fromorbit.com/

and combines the cleanups proposed by Christoph in this patchset:

https://lore.kernel.org/linux-xfs/20210519190900.320044-1-hch@lst.de/

THe code largely ends up in the same place and structure, just takes
a less convoluted route to get there. The first two patches are
refactoring buffer memory allocation and converting the uncached
buffer path to use the same page allocation path, followed by
converting the page allocation path to use bulk allocation.

The rest of the patches are then consolidation of the page
allocation and freeing code to simplify the code and remove a chunk
of unnecessary abstraction. This largely follows the changes the
Christoph made.

This passes fstests on default settings, and mostly passes with a
directory block size of 64kB (16 pages bulk allocation at a time).
THere are recent regressions in 64kB directory block functionality
in 5.13-rc1 - none of which appear to be a result of this patch set
so I'm posting it for review anyway.

Cheers,

Dave.


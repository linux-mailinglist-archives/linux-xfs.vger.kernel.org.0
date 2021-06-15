Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94103A7755
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Jun 2021 08:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhFOGtP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Jun 2021 02:49:15 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55958 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229918AbhFOGtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 02:49:14 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A1DE41043B8A
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 16:47:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lt2qj-00CwrS-Ac
        for linux-xfs@vger.kernel.org; Tue, 15 Jun 2021 16:47:01 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lt2qj-003aCd-2U
        for linux-xfs@vger.kernel.org; Tue, 15 Jun 2021 16:47:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: xfs: fix CIL push hang in for-next tree
Date:   Tue, 15 Jun 2021 16:46:56 +1000
Message-Id: <20210615064658.854029-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=Fa9Byph3n1uq9-sGu_MA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is the first fix for the problems Brian has reported from
generic/019. This has fixed the hang, but the other log recovery
problem he reported is still present (seen once with these patches
in place).

I've tested these out to a couple of hundred cycles of
continual looping generic/019 before the systems fall over with a
perag reference count underrun at unmount after a shutdown. I'm
pretty sure the hang is fixed, as it would manifest within 10-20
cycles without this patch.

The first patch is the iclogbuf state tracing I used to capture the
iclogbuf wrapping state. The second patch is the fix.

Cheers,

Dave.



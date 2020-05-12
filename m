Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E4B1CEB01
	for <lists+linux-xfs@lfdr.de>; Tue, 12 May 2020 04:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgELC76 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 May 2020 22:59:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53313 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728110AbgELC76 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 22:59:58 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CDCE4820966
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 12:59:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYL97-000239-6c
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 12:59:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYL96-007aCY-Tz
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 12:59:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: fix a couple of performance issues
Date:   Tue, 12 May 2020 12:59:47 +1000
Message-Id: <20200512025949.1807131-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=g7MSC_FphxsJ-jSkoP4A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I was comparing profiles between two machines and realised there was
a big discrepancy between them on an unlink workload that was kinda
weird. I pulled the string, and realised the problem was cacheline
bouncing interfering with cache residency of read-only variables.
Hence the first patch.

The second patch came about from working out what variable was
causing the cacheline bouncing that wasn't showing up in the CPU
usage profiles as overhead in the code paths that were contending on
it. And for larger machines, converting the atomic variable to a
per-cpu counter provides a major performance win.

Thoughts, comments, etc all welcome.

-Dave.



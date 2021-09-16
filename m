Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA65140D15C
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Sep 2021 03:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhIPBsP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 21:48:15 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:37599 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233662AbhIPBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:48:14 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8900E1B9ED4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 11:46:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUG-00CySb-TB
        for linux-xfs@vger.kernel.org; Thu, 16 Sep 2021 11:46:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95-RC2)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUG-007hWl-PH
        for linux-xfs@vger.kernel.org;
        Thu, 16 Sep 2021 11:46:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfsprogs: generic serialisation primitives
Date:   Thu, 16 Sep 2021 11:46:44 +1000
Message-Id: <20210916014649.1835564-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916013707.GQ2361455@dread.disaster.area>
References: <20210916013707.GQ2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=7QKq2e-ADPsA:10 a=snicdmRGJRe3wQwVQ7AA:9 a=0iaRBTTaEecA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This is where I think we should be going with spinlocks, atomics,
and other primitives that the shared libxfs code depends on in the
kernel...

-Dave.


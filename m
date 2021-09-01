Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174B93FD46A
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242584AbhIAHbl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Sep 2021 03:31:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54868 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhIAHbk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 03:31:40 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 25D62104E3BF;
        Wed,  1 Sep 2021 17:30:43 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-007NLI-H8; Wed, 01 Sep 2021 17:30:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-003Xnt-7U; Wed, 01 Sep 2021 17:30:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 0/5] xfs: various logged attribute fixes
Date:   Wed,  1 Sep 2021 17:30:34 +1000
Message-Id: <20210901073039.844617-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=9dvmesDmpY1Fu1fiU4MA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Allison,

Here are the first set of fixups I've made while testing this
series. The intent whiteouts are generic so I'm keeping that
separate, even though it's the change that fixes most of the
performance regressions for small xattr sizes that result from
enabling logged attributes.

Cheers,

Dave.


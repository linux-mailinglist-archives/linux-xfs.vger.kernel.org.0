Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D1B27E123
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Sep 2020 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgI3Gfi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Sep 2020 02:35:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45958 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbgI3Gfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 02:35:38 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8BD7882672D;
        Wed, 30 Sep 2020 16:35:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kNViB-0001S8-6X; Wed, 30 Sep 2020 16:35:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kNViA-000b2t-Hy; Wed, 30 Sep 2020 16:35:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     nathans@redhat.com
Subject: [PATCH 0/2] xfs: a couple of small fixes
Date:   Wed, 30 Sep 2020 16:35:30 +1000
Message-Id: <20200930063532.142256-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=reM5J-MqmosA:10 a=HfuvgWlOyF8BupQZd7kA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These are fixes for the problems that Nathan Scott brought to our
attention earlier this afternoon on #xfs. Many thanks to Nathan for
finding these issues.

Cheers,

Dave.


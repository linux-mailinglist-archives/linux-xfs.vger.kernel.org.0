Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4B9AAF86
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 02:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389683AbfIFAGA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 20:06:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38174 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389085AbfIFAGA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 20:06:00 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1A5E843D977
        for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2019 10:05:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i61lD-0003ZJ-Db
        for linux-xfs@vger.kernel.org; Fri, 06 Sep 2019 10:05:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i61lD-0001mO-9h
        for linux-xfs@vger.kernel.org; Fri, 06 Sep 2019 10:05:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH0/8 v3] xfs: log race fixes and cleanups
Date:   Fri,  6 Sep 2019 10:05:45 +1000
Message-Id: <20190906000553.6740-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=J70Eh1EUuV4A:10 a=ue-7-B9M8FX5BRU8tc4A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Version 3 of this patchset, largely the say as version 2 except with
minor comment and code cleanups as suggested by Darrick. V2 of the
patchset was confirmed by Christoph to fix the generic/530 hangs on
his test setup, and Chandan confirmed that the version 1 + patch 3
fixed it on his machines.

Cheers,

Dave.



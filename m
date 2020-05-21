Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513FD1DC53D
	for <lists+linux-xfs@lfdr.de>; Thu, 21 May 2020 04:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgEUCfs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 22:35:48 -0400
Received: from sandeen.net ([63.231.237.45]:41440 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgEUCfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:48 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 879BB1F1E; Wed, 20 May 2020 21:35:19 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7 V3] xfs: quota fixes and enhancements
Date:   Wed, 20 May 2020 21:35:11 -0500
Message-Id: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Once more with feeling, this rolls up the kernel patches sent in the
prior 0/SEVERAL series, with the fixes Darrick pointed out.  sorry this
has been such a mess.


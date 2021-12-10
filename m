Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00EA470BCE
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Dec 2021 21:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344186AbhLJUZb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Dec 2021 15:25:31 -0500
Received: from sandeen.net ([63.231.237.45]:43500 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343918AbhLJUZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Dec 2021 15:25:29 -0500
Received: by sandeen.net (Postfix, from userid 500)
        id 8AC6F4917; Fri, 10 Dec 2021 14:21:40 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfsprogs: misc small fixes
Date:   Fri, 10 Dec 2021 14:21:33 -0600
Message-Id: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A handful of minor updates after encountering poor documentation
and minor bugs while dogfooding and reading user questions.



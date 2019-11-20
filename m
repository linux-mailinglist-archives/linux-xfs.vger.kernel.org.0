Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A25103876
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Nov 2019 12:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfKTLR2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Nov 2019 06:17:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTLR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pqAkvAqX9CKDzHGXtxql4FUPrZ//DrdKWGHu3vpZRv4=; b=tZmfMwUQK+acbngvBKuqH1pcK
        ytt5gboggi9RI6/Fr/Xji/gVZH+R+2YRAfUMaPVXu2SCphWpFZIO+2j1jzUCgk0OEW8UvJp3AnoBc
        uHRY8gMJLFH9vy1cj6FmOQwBPN827/paQHOUR6uBtil+7Q10zKl3+LGw7mhOhiCSr8fJMVKjYb8RT
        PHcPYijaRf5jm7P1P1M7/qXFILtkUSJn+ZVygH45rCQJXxXsD4I5ovkceQEYtyhtuTW2MibCC1OoL
        pHPIfsQzpZLcHWMUIyQkAfIrnQ7CxuuJgMKc1dxh7F62HTZnwNU+ZoQ4tvZfuSe4XTZn8lxIPUCTC
        ZPyK5MVwg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzE-0001Q0-4q; Wed, 20 Nov 2019 11:17:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the dabuf mappedbno interface v2
Date:   Wed, 20 Nov 2019 12:17:17 +0100
Message-Id: <20191120111727.16119-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this (lightly tested) series cleanups the strange mappedbno argument
to various dabuf helpers.  If that argument has a positive value
it is used as xfs_daddr_t to get/read the block, and otherwise
it is overloaded for a flag.  This series splits out the users that
have a xfs_daddr_t to just use the buffer interfaces directly, and
the replaces the magic with a flags argument and one properly
named flag.

Changes since v1:
 - return *nmaps = 0 for holes from xfs_dabuf_map
 - add a new patch to refactor xfs_dabuf_map

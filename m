Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63925ECABC
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2019 23:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfKAWH3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 Nov 2019 18:07:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWH3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fPDpdg7+JxmF8laR7bY1qFJu5se17opi2BcOYfUudQw=; b=TQQ50ozF7Pzo9c5Nq+1kDEHOx
        lWaNbMOOsDJ+Bh/t8BEyEC5U5pWtfF8+dxTnBtCyrdG+BfGSCPOyrzW7FQxZLPzvGCkZdcdIbMK9G
        X38tks91/Z4pnVKrQRUHo4PZFFFZ5uRYl8YhUswhHWMF5AN6mFaU2t//IgrfsH/V6/7HzKCYuy5nP
        T/7OLyl/OivAJAl0gdjhgMLg9AfguBxVd1piAXtCOBy5Hm7WOYeGunBmoFcGNGjaAcX0/nosQqKXU
        KyaboB6dbuActIdfJQuW/xnrK9rSMXnmd4i/pd+DjJdBiUVI+CGoVvRcT8TLrWNGZa9ymW3hCTHOM
        bDm7jOyMQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf4r-0005qE-50
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:07:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: remove m_dirops
Date:   Fri,  1 Nov 2019 15:06:45 -0700
Message-Id: <20191101220719.29100-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series removes the indirect call to distinguish between the v4 and v5
formats for dir and attrs btree blocks, and for file type enabled vs not
enabled formats.  Indirect calls have always been rather expensive, and
gotten even more so with the spectre workarounds.

This series removes almost 700 lines of code and shaves almost 6KB off
the size of the xfs module.



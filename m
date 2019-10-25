Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CF3E416B
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 04:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbfJYCSz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 22:18:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389816AbfJYCSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 22:18:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I6zg23RuNq+Hv4ViYlqe+CFwAgSp0ehYT8YaTAXSA6o=; b=LVQx4wIM13cw/PLz/HXd7gJ5V
        dG++saZP75HMmBHoCRNSVYK3NQeLg/6ZIOtvWBojbtJ3rahc7gf4iLM4XRbPNGlkx3qSDHKjsC8WP
        Hc1jmJEexxIqb+EbHCY9sDhYgSUwMPn6bI1boJ0kKywICHzavfGJoXWYVCWpSD32SrOuriOmupzEb
        P18esiHyfNUdCOrx2FvwQkql1kEuRtljQhJMbWNVktKe2H6fsTzXbKk5tAUZYOEMq26cHOjdXlTpW
        jo9Wl3RcbeOqiCQtwLRzsdrjOyg+LkoAuEvbmUfBCI7IwStoC/kClJA4yPMAhfj7Q4zlez0gDRBMQ
        r18mTWIjg==;
Received: from p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp ([153.156.43.6] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNpBm-0005UG-N3
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 02:18:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: cleanup buftarg lookup
Date:   Fri, 25 Oct 2019 11:18:49 +0900
Message-Id: <20191025021852.20172-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series merges our two helpers to look up the data device for a
given file, and uses that helper in a few more places.

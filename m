Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFA18C7AD
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Mar 2020 07:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgCTGxQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Mar 2020 02:53:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTGxP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 02:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=4ab4pGO8GthFIbDNXEa8Bupb3hBthLYFHEU0u96/f2E=; b=Acz4eUX12GEBOIwIc+kubjfl3W
        TPihy1eep1aYHCaJb7MEI0b9a/IafBTlqgmahJfbPAxvZyx02oDMUyNsTdONPSemQYh+zL+3c7dQU
        I4RVtCCtWRLyzz1asA5AeckDJchJgEQsaYkJtkm/vHybSwproE40DM7OqLuC4ZMmhgXC0/4wxgdnO
        wubCwGefHkUsMHPC9WIN/0preMjswLJyISuC6FstooYrqlk61NLFDaJezWIdqwZmqc+Hf3d8YnfOT
        8zrcrvaGTo9wbC1Sft5LJZZ+rtQYFOFVSDLvIkUSyQVs/s5mtBMq0HXg43RCYrdj5Rr+LQVUALNQh
        vK+Lpwww==;
Received: from [2001:4bb8:188:30cd:a410:8a7:7f20:5c9c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBWr-0006Dv-PW; Fri, 20 Mar 2020 06:53:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: more log cleanups
Date:   Fri, 20 Mar 2020 07:53:03 +0100
Message-Id: <20200320065311.28134-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series contains more uncontroversial patches from the
"cleanup log I/O error handling", series.

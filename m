Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E921AA34E6
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 12:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfH3KYO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 06:24:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH3KYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0HVfO1bpzSi1ZZGDJvjkuf/mAsphbFA8/JTA/C9/M+M=; b=uCm/46FW3z4XleS/2RJ7wwaYK
        bYTnc7citYu1hgwDJy0sVecYe44sfd8jWofV3a+yVQYmmnNQth4j0Ggro9iQ//4usi2OYTNopmhd9
        L7EaPl685tUdxF9rtVyfBSk3qRPU+6VWq07W1hL07JFKtgdg1vVknfUpWvd/7cAGlToC+2T5bvgyo
        EquOKUrvU/b4tiAJTTXoRz3Ck7JhmQZe+hTtXUlQ55XfjTe4eM1/CCGTWb8AvBshipwygrn4J1Hd5
        Pd/Tj/1+0QBRvpl1m4HvSZD3zAa3D1VyE6TKWXG2BkQZnvizgWqoyuJW9p/rd/8IZT/B/MwFwxcoJ
        BeCMBPHyg==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3e4j-0003oP-Qv
        for linux-xfs@vger.kernel.org; Fri, 30 Aug 2019 10:24:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: misc cleanups
Date:   Fri, 30 Aug 2019 12:24:08 +0200
Message-Id: <20190830102411.519-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just a couple random cleanups from invesigating a larger project.

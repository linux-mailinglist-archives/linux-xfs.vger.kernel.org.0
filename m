Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF77D1141
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 16:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbfJIOaG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Oct 2019 10:30:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42158 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIOaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=x4LSObAhKqmFt6oyZfcyEERYHPzT/CeEvm+laZdhmKw=; b=obgsNcWrgDHtc9dxaHyT9pXxH
        wYoiKc5W2wHqFUb7cdc1WlQtS2xuBy2K4JbnVqcJvAQYSGhr2HvCn9X8XdWD8dR0ZtaQfh3T7mgJf
        AgyXNMY5gVVGZYwXpWGZdmQ32BqwLd8rCnC4ZN/LPiWW1zRKQ44z/HE/AhNWJLFOYfayW3l7878fL
        dKHpdOANiYuc+Q5FijQoz1NDssqx9zJ2DNhfKUkFR+XuI7nbYXDrkmv3BwqzbkiuwXYyrf1AGdwRa
        +XeKUJAj7Uwof+CsjA8Q3tjQJD/4fwJsR2ZPvLl2i2fkc2wdc28Qq2eH6Wgq8g/79nZvHq9bqCtKN
        MjLDClQMg==;
Received: from 089144204014.atnat0013.highway.webapn.at ([89.144.204.14] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iICyb-0004DD-9N
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:30:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: misc iclog state machine cleanups
Date:   Wed,  9 Oct 2019 16:27:40 +0200
Message-Id: <20191009142748.18005-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series has a few patches from tidying up the iclog state
machine.

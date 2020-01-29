Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD1A14C6A7
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 07:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgA2Gt0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 01:49:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgA2Gt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 01:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A3pUPllyaOYMKcYI7i+rHrQB0z7lwnlX62MlwyIYIOU=; b=J3sou6a6bF+jLbfUw8d/r+1F0
        osFFP+3felvEAX41ULlloJOgTDkj+yE93b425cAN+9aty/sohFT2wHtGyxP265Hv5ZRg4HXkRdtwY
        uCnLEBAyeNCF6vPVLze3458z8ZKJRhp1rNY5y3ipkKd01+dnUSVP/RLaF5Qrz9o9Cp/YXuYlWLutB
        i1U6wWXYQzZz4oOxL3wqU6yCzEJUhGDabX+JXc7rqi5BLcBbnOlFOC6btgd4VedueaTiwq4dKON25
        Mjkxj2o8ABtSpIMJlM7/JrrTkY9zH9ClBtSIWbhDuh7MijbYNjWBAolANWXwLNm9vSDSU6MVhfoh+
        5BWM+BBrA==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwhAD-0001SW-Gk
        for linux-xfs@vger.kernel.org; Wed, 29 Jan 2020 06:49:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: stop generating platform_defs.h V2
Date:   Wed, 29 Jan 2020 07:49:18 +0100
Message-Id: <20200129064923.43088-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series gets rid of the need to generate platform_defs.h from
autoconf.  Let me know what you think.

Changes since v1:
 - check for bytes, not bits

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2840821454
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfEQHcJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfEQHcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9B/xfvEIHrtIA5HJt3b9a4vyMzgLcj4hXB7Hk98qVjA=; b=ndRq3yfIS+bzzqv6MTpECx1wY
        aWwsS0XA9F5qrKUH2vcuvkUqQf7muxajRMw64SBhemh0NXHy51r3jzFEf+K3enPLdIeLz3bIw+t03
        HXzjyCV5m1tGRq9bN6+gVdezEO3mRuR6tVV2cT3l2CI1uwlF89k59IXcpqZoSq4ll4wqYTlsj91xm
        IHipFHBHLjuOmVSDPzzhLM5KjTCC3tHtuJFmFLa0D8OninxoqNQI3qWZ5TaD7DKgSc9IODjBCFmfY
        +3c3bS5q3Mhhx7UcRduRhb5r2TSEUPZMzOo+wQb5nIaJususgSr7OAzXfiKuX//9gPK6KaNMBmWAi
        VWwQoHZAg==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLc-0000ht-3L
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: misc log item related cleanups
Date:   Fri, 17 May 2019 09:30:59 +0200
Message-Id: <20190517073119.30178-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've recently been trying to debug issue related to latencies related to
locked buffers and went all over our log item lifecycles for that.

It turns out a lot of code in that area is rather obsfucated and
redundant.  This series is almost entirely cleanups, but there are lots
of it.  The only exception is a fix for systematic memory leaks which
appears entirely theoretical.

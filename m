Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A1E245CB6
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Aug 2020 08:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgHQGzf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Aug 2020 02:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgHQGzf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:55:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5629C061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S/4SoWkBwGAHqBQjps5c2SzKFBNf95MIR+rb9mXz8Og=; b=NFKvOLu35U/aDyvam8wU42pqXW
        GsSs0CYBFvmZZh4OHqbzLigNwnUB3OtGe4K6VDetU348E6Pu/8YGrePpBxlsDkCRT+G/IngSCcSiL
        QMekQMx4UDYdqFImoee2zuF/kk3VSQDw7KOW1S9xVaElmcAAVmAOFhcSU9LGDniXfI4wGn6yj5dtW
        7R5h5lSNQxjF64/3KG/ZqGUv330ZbBkQW7kWwRC1gDO04dOF8B2nAG5v1D/EzMqK/Y5gp67CsSYVz
        seOe5E5uFp2N4rgLiKTn5Oid3mcqUCvg8PhL5sWfDHixppSNsA+5yPgUXEAmCtORKe6hEusbB3sIK
        x+uQHJZQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z3N-0006iY-Fd; Mon, 17 Aug 2020 06:55:33 +0000
Date:   Mon, 17 Aug 2020 07:55:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Get rid of kmem_realloc()
Message-ID: <20200817065533.GG23516@infradead.org>
References: <20200813142640.47923-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813142640.47923-1-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both patches looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although personally I would have simply sent them as a single patch.

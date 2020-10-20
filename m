Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1828EE95
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgJOIf0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgJOIfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:35:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAE9C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=sAtSiBVKWUcIKLFA1rkiPgQvI/
        sXnJRfpkF+BnkmWLxD1uFwyY8nV25dnhl16J8WW9efP0fO2xDRPCEIgoVh2R5n6J60ylsBXyA3R3R
        op3sV7rUGjXeTSJ03OwnexgKD7N8SCe1sOyGHvn4mrMqLPrCSzHrsWR4VR55fjjh+ghsySsmpr6kF
        A3A6VGo/GUs9v9diFmZ2Fi8int+hRmnsHeNFtROauXjXthk+dJjkZ/BvUwUf2dH8+SAIl1wcuU4xH
        cmFJV4cJEbe8mzxkHhC0i9VOEpR1OnQWNbjdYlYYgWSqqgq8HpVYqNLQONCedKq62KxQSaymfe2cO
        LXPMaMoQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyjM-0001nW-2S; Thu, 15 Oct 2020 08:35:24 +0000
Date:   Thu, 15 Oct 2020 09:35:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 03/11] xfs: Check for extent overflow when punching a
 hole
Message-ID: <20201015083524.GC5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-4-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

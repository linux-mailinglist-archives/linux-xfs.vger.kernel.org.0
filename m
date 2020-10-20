Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7DD28EE5D
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbgJOIVT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388046AbgJOIVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:21:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79A7C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=E4COiEfLfQrn4mgQlsPzfs8TVd
        nTxU8z5nLqj7KTGh7mCU97EhdvKBvrbo8ORY1R3jxAoILhFYUvFJfKZS2n9iI1kyXlqa9P1dtfPg5
        vq8OhjUFQWGSOz/6Aj9rZEXulPYkFYcLjt0mo3AfLsR+awAfQNUcw9go4TUoOKuYqD8WqiJHPloSY
        Hp9ibSqjqGPNZ+3RsMTRQdW1w1eQcHucBFKcEtJxmrhdzIhjhPDBHf50EQa918dImu4gOBHe1VVz0
        ChsGkhrtUIkHkC6wBiUQxk4vPgTzpXRtFg0bIcFU8F/10huhBqE/Pf9szwD683Ein09MJX9+OV09b
        IBIpn2KA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyVh-0000vL-JG; Thu, 15 Oct 2020 08:21:17 +0000
Date:   Thu, 15 Oct 2020 09:21:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201015082117.GE1882@infradead.org>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-5-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

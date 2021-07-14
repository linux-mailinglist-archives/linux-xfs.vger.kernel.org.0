Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246143C7E7B
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 08:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbhGNGZH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 02:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbhGNGZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:25:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122C0C0613DD
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iBRmgc+z36jrMeLYRYReCtfBxnPvYXw5JsPwCkgR+YA=; b=kJER8mZx7Wm+Xxc+V0SNrYIRhs
        QHdtPfPIDhc4/eELl83rFmXnlTKfUyoSBXUBIJy9K/nv1PGeA9tsbSLP5SG1gZYO+TBpcoG9bl+dY
        Sl9O8tji3sfrVpeirzcXCoojd9P4EJkhDQu9oEtVimaM227bKhDGQTxqs9yR3n7yWxPCtlXR4Y8vA
        NkyiZmtTAOl657o/cOdi3WpVkwAh+nDJs09OY7zGQ5qqmvSBQ1T4lz6k83RL2sRr7lvkaMhFV3rgO
        hqgyCXu8FWVLjXVVjTYFhxeuF4dZEpC/cL2iz1rAe+R7GHLdr5C/21B9uVytmvnan/v+LBhL+9ECp
        tyMGgFLQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YHB-001v1a-Ut; Wed, 14 Jul 2021 06:21:56 +0000
Date:   Wed, 14 Jul 2021 07:21:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: attached iclog callbacks in
 xlog_cil_set_ctx_write_state()
Message-ID: <YO6CeWqKnK9eJGrr@infradead.org>
References: <20210714033656.2621741-1-david@fromorbit.com>
 <20210714033656.2621741-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714033656.2621741-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

s/attached/attach/ in the Subject.

xc_push_lock around the start_lsn assignment still looks weird and
unnecessary.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

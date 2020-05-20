Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58F31DAB2D
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgETG5o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 02:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgETG5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 02:57:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE474C061A0E
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 23:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O+/bo5qVkNc4jdpYOO1OHH+32yZTAMnHqLPp+/yJCNM=; b=QF5WQ3xfdy+71VPjd1dylykdnC
        5Bzk8eGVRAT+gEXXVqFkV/nnBgsZEg7wUPsXhPMvcLG5g7crtEMzl4F+PfSljrwU7ETKABpECPQKm
        jMegSzLgCiU5YwFUxqLK+n8j9CxM6UgGRJpYiczHYe8yQakzV5kAbnUWTfK+FDh2PRznqiMeygpT+
        pOarO03dWcbqEYnIr6ulp2iqujSeiLo/NLaZxS+14gVDL4SWU8JyQIzT6uYBJIqgSEdWcAcMBY4Ya
        7MaXsgPZD8JqzMPesSlCoy/cn12U7VViFwzBgDdMIjGpSYXxrc3toyFgaxUZcRrOo58Brv61l9HCp
        ryRBcNJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbIff-00031Q-LS; Wed, 20 May 2020 06:57:43 +0000
Date:   Tue, 19 May 2020 23:57:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200520065743.GC25811@infradead.org>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519222310.2576434-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Shouldn't m_errortag and m_errortag_kobj also go into the read-mostly
section?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

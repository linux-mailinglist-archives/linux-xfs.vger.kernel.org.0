Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FC11D7F65
	for <lists+linux-xfs@lfdr.de>; Mon, 18 May 2020 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgERQ67 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 May 2020 12:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgERQ67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 12:58:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F31C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 09:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+3FHPwcXvpv730ElxvnFZTNme0UBLd50jDF0Sm9oxE4=; b=VdtllQ2TrTJsgpU/qiPvJqrA33
        jv5/UVLMNqkCN57kgUCgoKHShDCVV3+KioFjNVjWTNQHjEG5o8IIzZ2JiDhu7dErI4EqVVMwmKYGe
        JZRM4ZcN40Fo/0RXPJUPyLgDxT6UmKGT9EqpF0KIxnKbqpE7efyZ01t0E47LPFquvVl2+3T9VczLL
        wOeIT898LYE6J9oyXgCoRnMaB1MTMaFPLtuBmPKLTXm7jUoOgXyMPrixX5UIOpGMWGwtEIhbiFsEH
        LaOWyOYuvDzzgZeAxJlzrZONvl0n4Csyzt3aSaAhDCgItFSX4sKLR0fHgCl5AV9lWWooYY9FKuFad
        e/7hUeYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaj6Q-00056n-SL; Mon, 18 May 2020 16:58:58 +0000
Date:   Mon, 18 May 2020 09:58:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        david@fromorbit.com
Subject: Re: [PATCH v2] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200518165858.GA18061@infradead.org>
References: <20200514165658.GC6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514165658.GC6714@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I would have split the addition of support for order buffers to the
defer mechanism into a separate patch.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

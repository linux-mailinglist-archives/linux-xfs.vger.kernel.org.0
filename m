Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD4F28EE58
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388027AbgJOIRc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387981AbgJOIRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:17:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31B2C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=K1uv73zsrNRdqnq/rEmMWf/38Q
        NkDgS/EaJGHrpq03p6TisE3PLQmqkUgVWzDvQ+gvGLcOupzI37sT9VCIr3/K47JJZGylQVLoqVbh5
        Auo3OC+KQ4+k5XQTtwmtr3cIZFrPHeF0LwJi2WrLjIMucsteI/DCBuGSSw6LjScCb7shV13jo3cwn
        C+y8zJY6PwWL6H+IB2cb5eLFKlumUT2kn1ZnRhvbdP1DA1FRFoNMscWtYXY3wodKHqDTUZZ0YnaAl
        +sVIjdz1Vm5uWpqe21rr3PuhhZz2KOrB1UkqpGy4kpW7RGxIx8tPCIsSNOp3376nFUzFspxllt8Vz
        ZPo/fxUw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyS2-0000h4-KM; Thu, 15 Oct 2020 08:17:30 +0000
Date:   Thu, 15 Oct 2020 09:17:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 3/4] xfs: xfs_isilocked() can only check a single
 lock type
Message-ID: <20201015081730.GC1882@infradead.org>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-4-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

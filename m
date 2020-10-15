Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BF328EE9E
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgJOIgr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbgJOIgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:36:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F4EC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=DGOiuVuliNceGjfCKcSf9d/cG1
        Y+HCO/iMMZne7LzuYtM8hXarKbIavtQENrpy7qKqzMVHjAjeKxhyJqambDIZ99TQyyOdU224C8u6X
        HFs3gD8fMTvJJK40X/XcWUH3OV5uAaVGD9gTu/37y73mDi9jkm5luhIeJiYYZajd+vt5YR1pZaHqs
        Hc6iWKNh7ZoseWZJcJ5Kok91tP58cZ3OCRjAspRPPnN/zwOjAmoKNtZvJMfrLx6SoEev2JIxILRWs
        0aMyeEb+sUg+vdGkLKvX6ve8hD3C5DS36nYF4MCtVFOIm0ELSbIAyJ3h/atPsCXvZRIX3mWslMg57
        kxoxX/QA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSykf-0001tS-6j; Thu, 15 Oct 2020 08:36:45 +0000
Date:   Thu, 15 Oct 2020 09:36:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 06/11] xfs: Check for extent overflow when writing to
 unwritten extent
Message-ID: <20201015083645.GF5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-7-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

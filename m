Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624231C0EF7
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 09:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEAHoP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 03:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgEAHoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:44:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286B7C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=S+XGYiF2zIwIYOSlwirMBNuvci
        ZDlbm8uMaQ5lUrPUfObBNLX6f4wht7ca0l4pOsySTJRqnyKzLcf/NA27eXGgk/DczejKKZemKwQqH
        OKTj5tXXus31CvTN1ZHfkWe9gUEX5Iwv4OwQxJIQarlCA0slZSbArAuMYurrKNAr6bSXC1U6g4Py8
        dmYOJInzNVek575ySO+xuxeUDNCmBhGIp0U2uuOeVZgzaSepNAqq5RkH4VQjFNTmfr0VDIf2WhbPz
        zW9M5urB6EDjxFq9CDnb07pJR2R5/jhkPwMInn8Ge98vD/1MslmWUU9Ttzz07J0CWA+BYH+lSZPxF
        jfKnad1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQLH-0008CF-1S; Fri, 01 May 2020 07:44:15 +0000
Date:   Fri, 1 May 2020 00:44:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 05/17] xfs: reset buffer write failure state on
 successful completion
Message-ID: <20200501074414.GB29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-6-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

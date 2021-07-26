Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DB13D546B
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jul 2021 09:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhGZGzZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Jul 2021 02:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhGZGzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:55:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B0BC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 00:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ALaFJq2FWCNB5ue8WSL0Le16Zi
        XS8bPabPnn7r/SWN+1CuGrn5vWQx3zJ+0XWoXESN4p1otChBTB7jHnZ2XTPVJhYZibrJm32Ijql+3
        Bz4KoH8HQrwh7YLOZ81nKeqpptFcHX0pP8KtAvp+JAt9h34cV6iphrIzsVeS5CklLWOj31zUJhI/t
        VBOjcS6YALCAvjWyJjP/geyTOZc2WsgdzBdz4vKsN2qerktSZL6KAJSUZJb4cNays+gbHyD0296xL
        s5XEd72FpWcBoVxhdAZCoFF6ozX5cfy7J1SyX1C92fGKHkOK9ESvwsYB+knu7oCYa8MM6J0leUGhn
        1YQOaeuw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7v94-00Dhyh-VG; Mon, 26 Jul 2021 07:35:33 +0000
Date:   Mon, 26 Jul 2021 08:35:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: Enforce attr3 buffer recovery order
Message-ID: <YP5lvtMtYcqnu4A5@infradead.org>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

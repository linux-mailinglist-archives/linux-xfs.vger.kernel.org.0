Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5563C47EC70
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Dec 2021 08:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351714AbhLXHHE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Dec 2021 02:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbhLXHHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:07:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFD0C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qlDGOXlPCbTVC/vD8UQk2xtle6
        4SCnKv0nqp9SVRoM93yX9Ikn9METNQh5sL5/gJz62Pf7zmLBTOjditCZSxyS9BNn+Nd1NfMSLxYHV
        Jy5i4Z10BuS0MyVTpFePdrrgdM755lKXPCWWliZ61PxMppZbgUo9EfhesrbLi0fn2wOmdEvHjzbV+
        1utIQ4hZom7EpvjUAqnWZovpxG+cxP74ynod82H3cny4/CFzxVfdqfGg5DmHSsLfh74R4d7nonrGJ
        ojVOsJNWMO4pgIfh4Iu7ZcJCaF8rvObp5NEnHwZhewsuuMRARzTc4avkB3fluSHfWcSeUQGbFylfC
        HiHuFTWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0efP-00DpYr-OC; Fri, 24 Dec 2021 07:07:03 +0000
Date:   Thu, 23 Dec 2021 23:07:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check sb_meta_uuid for dabuf buffer recovery
Message-ID: <YcVxl7MlszQTmQDG@infradead.org>
References: <20211216001709.3451729-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216001709.3451729-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

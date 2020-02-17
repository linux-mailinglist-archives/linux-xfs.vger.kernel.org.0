Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE0161398
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBQNdf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:33:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgBQNdf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:33:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XaZrHQ0L88dyac6xM11F6o3QKXC6kwzJgk4IwMXBAs4=; b=IYc03eNMf5PN08UK1nPFRFdiko
        V51947KsvCWx5DdLbz/ewAE1R8pVh+iLlgrowoJNhqhAkccfTzOuKDETYjJ3okYE3q3yCQ01gL+16
        /WyCXgm0wr8ty2arnwUWftq79ha4otLVRUoEdav8NaWtBWr7/lAM7WUjMS28PgctBjw2B4RCH/Qg4
        GLKwdoEJjMbPC7vEZd4SMSQQXxgY+tws6s7fHR7JQ67OhNZjaNhBPopU03gdjf+Uh2I1qHA3QBDWS
        DPeLmmD1YZ2XaPEam+Dhx4c1q88by39h3x7b2sA92rO2vsKRgKOcKdwcg1M8RlAHovqm4FIhIihFP
        bwxMK/SQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gWl-0000S0-AD; Mon, 17 Feb 2020 13:33:35 +0000
Date:   Mon, 17 Feb 2020 05:33:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Message-ID: <20200217133335.GB31012@infradead.org>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200214185942.1147742-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214185942.1147742-2-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 14, 2020 at 07:59:40PM +0100, Pavel Reichl wrote:
> Make whitespace follow the same pattern in all xfs_isilocked() calls.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

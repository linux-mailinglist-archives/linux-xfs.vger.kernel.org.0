Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA5A228451
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 17:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgGUP4B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 11:56:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21870 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbgGUP4B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 11:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595346960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qrC2X/jZHrAKI9FJpAizdCRiq0dJS1Ska4sAsRwCrOM=;
        b=KzHyrjvWTvU+Rkh9qA5kG2sH7BotTptM8+BzNlZgM2FpsV0IOH7w43QmLriAF1VOc1yKcj
        TdoDAw6YB4a11yN0bmtbreNGAA0JS/xWmcG01Xa4wyUTkyCtz147A7O2CgBR+3vGJ2l6WL
        PzMNM/eZGPGRFpWLNi2uv/MAgYUpOXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-oOHEOUiMNxu5-9L4RKtfpA-1; Tue, 21 Jul 2020 11:55:56 -0400
X-MC-Unique: oOHEOUiMNxu5-9L4RKtfpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0494FE918;
        Tue, 21 Jul 2020 15:55:55 +0000 (UTC)
Received: from redhat.com (ovpn-114-248.rdu2.redhat.com [10.10.114.248])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5847E1755E;
        Tue, 21 Jul 2020 15:55:54 +0000 (UTC)
Date:   Tue, 21 Jul 2020 10:55:52 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net,
        darrick.wong@oracle.com
Subject: Re: [PATCH 1/3] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200721155552.GA96787@redhat.com>
References: <20200715201253.171356-1-billodo@redhat.com>
 <20200715201253.171356-2-billodo@redhat.com>
 <20200721150404.GA8201@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721150404.GA8201@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 21, 2020 at 04:04:04PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 15, 2020 at 03:12:51PM -0500, Bill O'Donnell wrote:
> > Make the error messages for rudimentary xfs_quota commands
> > (off, enable, disable) more user friendly, instead of the
> > terse sys error outputs.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> 
> I think we should have one helper with the error message
> instead of duplicating them three times.
> 
Except that the error messages are different depending on the context,
so crafting a helper function that recognizes the context seems to
offer diminishing return AFAICT.

Thanks-
Bill


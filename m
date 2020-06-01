Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3641EA447
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jun 2020 14:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgFAM4l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jun 2020 08:56:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39384 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725838AbgFAM4l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 08:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591016200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S+rpauD06Psdr6VUQnaHjCjtFzN4v6n7drCq717z7BY=;
        b=V31tJug95XBGuR62gOOmqn6DdnG6TcqTWYKc0bCaPiEfTaUO1YtvfJisFbps3OnS/VZ8Da
        bnEoAhPg+ZV4c3srgiUIiOpHNa9wFR8oBtgTCainms0NeHQ6gkiZbBDXGuW6CttYx6nTr6
        dBp4nPIEMcdTUvCabioomdW2uqi6Q2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-hoBSJU5nPRqMjDlQM936AQ-1; Mon, 01 Jun 2020 08:56:38 -0400
X-MC-Unique: hoBSJU5nPRqMjDlQM936AQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D91D107ACF9;
        Mon,  1 Jun 2020 12:56:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 285E05C1D6;
        Mon,  1 Jun 2020 12:56:37 +0000 (UTC)
Date:   Mon, 1 Jun 2020 08:56:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: kill of struct xfs_icdinode
Message-ID: <20200601125635.GA2043@bfoster>
References: <20200524091757.128995-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524091757.128995-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 11:17:43AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series finally remove struct xfs_icdinode, which contained
> the leftovers of the on-disk inode in the in-core inode by moving
> the fields into struct xfs_inode itself.
> 

JFYI, this series doesn't apply to for-next..

Brian


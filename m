Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90114D124A
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 17:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfJIPVd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Oct 2019 11:21:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48054 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIPVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:21:33 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDmK-0004Ph-0o; Wed, 09 Oct 2019 15:21:28 +0000
Date:   Wed, 9 Oct 2019 16:21:27 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191009152127.GZ26530@ZenIV.linux.org.uk>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
 <20191009144859.GB10349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009144859.GB10349@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:48:59AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:36PM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so
> > the options that have values like "10k" etc. still need to
> > be converted by the fs.
> 
> Any reason you don't lift it to the the core mount api code?

The garbage enum fs_parameter_type thing.  Once we kill that
(and I *will* kill it), sure - it's a sufficiently common
case to have helpers for it around.  But until then I'll
veto any further additions to that trash pile.

Look at fs_parse() - every sodding value added to that enum
turns into an extra case in a large switch.  It's unsustainable
in that form and I *really* don't want to be in position of
gatekeeper deciding what is and what isn't sufficiently useful
to go there.

What we need to do is to turn fs_parameter_type into a pointer
to function.  With fs_param_is_bool et.al. becoming instances
of such, and fs_parse() switch from hell turning into
	err = p->type(p, param, result);

That won't affect the existing macros or any filesystem code.
If some filesystem wants to have helpers of its own - more
power to it, just use __fsparam(my_bloody_helper, "foo", Opt_foo, 0)
and be done with that.

The thing is, "here's a commonly useful helper, let's take it
to fs/*.c" is much easier than "add a new constant to that
global enum and a case to that ever-growing switch in fs_parser.c".

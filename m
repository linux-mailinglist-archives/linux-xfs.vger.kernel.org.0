Return-Path: <linux-xfs+bounces-12189-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D737795F773
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2024 19:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5810B1F22454
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2024 17:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BA7198A0E;
	Mon, 26 Aug 2024 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YN8aoRHk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506961946D0
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724692195; cv=none; b=UGPWP92cyf1rTUVBACeVSWzLD/qvwbDLHDZWn0Btb8WmXiKTN7lrTPyBaSxYtw9HjqZpoQJPPz71oSl85WnsHi9QA6GJnFCcugdffG45+uK/Y+xsazYxzRWEE8Ms8urqPnB4OA19ojQNqid4Ah1xq0jOmKMrFGYosLVo5BV0syc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724692195; c=relaxed/simple;
	bh=4NJomvd1FkhRbF4teAxibD4t/8nSE3hcw3k3aFsC67U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdiuuZsd43+zKTVsJFa7ipFbl/JqQm1BiQFqLmKrlAKsTi5nkS6AFKOpC1hL4kUYbaP/8T8rKNDzWZPYmrPGEBIbxzplb2RL7l4VF02hI0GPF8GwwD5yAYqP58VcZdsCebGjK/Qdmz+5Kw6aK4bng5zptBR50ihQ4J+vRLqT23A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YN8aoRHk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724692191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0qn6hxlwrF0+8H5tQBVuv5gyNycLc//aQmQBBA/uTuw=;
	b=YN8aoRHkUcYTI12woCbDTsVw6ZwADICF5rbIckBcaIu2cuf+E5S7lKjdagZoHgigBRRRxb
	XTK5rTL17isNwN4VX7PyfM4FE3KqlkJpAPDpeSHQASWRWHdiJ/piHrDMa/asNxY2zH3VU+
	1xkVUXUw371y9MhT/MO0i6QVLjeSCWw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-UYkY999fOs22UI4dRFIZFg-1; Mon,
 26 Aug 2024 13:09:47 -0400
X-MC-Unique: UYkY999fOs22UI4dRFIZFg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78BED1955F43;
	Mon, 26 Aug 2024 17:09:45 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.22])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C2131956053;
	Mon, 26 Aug 2024 17:09:44 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:10:40 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 1/3] fsx: factor out a file size update helper
Message-ID: <Zsy3EEr8_gjGofaI@bfoster>
References: <20240822144422.188462-1-bfoster@redhat.com>
 <20240822144422.188462-2-bfoster@redhat.com>
 <20240822205019.GV865349@frogsfrogsfrogs>
 <ZsyLShYLojBLPNiC@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsyLShYLojBLPNiC@bfoster>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Aug 26, 2024 at 10:03:54AM -0400, Brian Foster wrote:
> On Thu, Aug 22, 2024 at 01:50:19PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 22, 2024 at 10:44:20AM -0400, Brian Foster wrote:
> > > In preparation for support for eof page pollution, factor out a file
> > > size update helper. This updates the internally tracked file size
> > > based on the upcoming operation and zeroes the appropriate range in
> > > the good buffer for extending operations.
> > > 
> > > Note that a handful of callers currently make these updates after
> > > performing the associated operation. Order is not important to
> > > current behavior, but it will be for a follow on patch, so make
> > > those calls a bit earlier as well.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  ltp/fsx.c | 57 +++++++++++++++++++++++++------------------------------
> > >  1 file changed, 26 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > index 2dc59b06..1389c51d 100644
> > > --- a/ltp/fsx.c
> > > +++ b/ltp/fsx.c
> > > @@ -983,6 +983,17 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
> > >  	}
> > >  }
> > >  
> > > +/*
> > > + * Helper to update the tracked file size. If the offset begins beyond current
> > > + * EOF, zero the range from EOF to offset in the good buffer.
> > > + */
> > > +void
> > > +update_file_size(unsigned offset, unsigned size)
> > > +{
> > > +	if (offset > file_size)
> > > +		memset(good_buf + file_size, '\0', offset - file_size);
> > > +	file_size = offset + size;
> > > +}
> > >  
> > >  void
> > >  dowrite(unsigned offset, unsigned size)
> > > @@ -1003,10 +1014,8 @@ dowrite(unsigned offset, unsigned size)
> > >  	log4(OP_WRITE, offset, size, FL_NONE);
> > >  
> > >  	gendata(original_buf, good_buf, offset, size);
> > > -	if (file_size < offset + size) {
> > > -		if (file_size < offset)
> > > -			memset(good_buf + file_size, '\0', offset - file_size);
> > > -		file_size = offset + size;
> > > +	if (offset + size > file_size) {
> > > +		update_file_size(offset, size);
> > >  		if (lite) {
> > >  			warn("Lite file size bug in fsx!");
> > >  			report_failure(149);
> > > @@ -1070,10 +1079,8 @@ domapwrite(unsigned offset, unsigned size)
> > >  	log4(OP_MAPWRITE, offset, size, FL_NONE);
> > >  
> > >  	gendata(original_buf, good_buf, offset, size);
> > > -	if (file_size < offset + size) {
> > > -		if (file_size < offset)
> > > -			memset(good_buf + file_size, '\0', offset - file_size);
> > > -		file_size = offset + size;
> > > +	if (offset + size > file_size) {
> > > +		update_file_size(offset, size);
> > >  		if (lite) {
> > >  			warn("Lite file size bug in fsx!");
> > >  			report_failure(200);
> > > @@ -1136,9 +1143,7 @@ dotruncate(unsigned size)
> > >  
> > >  	log4(OP_TRUNCATE, 0, size, FL_NONE);
> > >  
> > > -	if (size > file_size)
> > > -		memset(good_buf + file_size, '\0', size - file_size);
> > > -	file_size = size;
> > > +	update_file_size(size, 0);
> > >  
> > >  	if (testcalls <= simulatedopcount)
> > >  		return;
> > > @@ -1247,6 +1252,9 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
> > >  	log4(OP_ZERO_RANGE, offset, length,
> > >  	     keep_size ? FL_KEEP_SIZE : FL_NONE);
> > >  
> > > +	if (end_offset > file_size)
> > > +		update_file_size(offset, length);
> > > +
> > >  	if (testcalls <= simulatedopcount)
> > >  		return;
> > 
> > Don't we only want to do the goodbuf zeroing if we don't bail out due to
> > the (testcalls <= simulatedopcount) logic?  Same question for
> > do_clone_range and do_copy_range.
> > 
> 
> Hm, good question. It's quite possible I busted something there. For
> some reason I was thinking this would all be a no-op for that mode but I
> hadn't quite thought it through (or tested it).
> 
> It looks like this is for the -b "beginning operation number" support,
> so you can start a test from somewhere beyond operation 0 of a given
> seed/sequence. As such it appears to make changes to incore state and
> then write the goodbuf out to the file and truncate it as a final step
> before proper operation begins.
> 
> Looking at how some of the current operations are handled, I think the
> size-related goodbuf zeroing is Ok because we'd expect that part of the
> file to remain zeroed, after a truncate up, etc., for example. In fact,
> I'm wondering if the current zero range behavior is technically wrong
> because if a zero range were to extend the file during simulation, we
> don't actually update the in-core state as expected. This might actually
> be worth factoring out into a bug fix patch with proper explanation.
> 
> WRT the eof pollution behavior during simulation, I'm kind of on the
> fence. It's arguably wrong because we're not running the kernel
> operations and so there's nothing to verify, but OTOH perhaps we should
> be doing the zeroing associated with size changes in-core that should
> wipe out the eof pollution. Then again, nothing really verifies this and
> if something fails, we end up writing that data out to the test file.
> None of that is really the purpose of this mechanism, so I'm leaning
> towards calling it wrong and making the following tweaks:
> 

Err.. I think you can disregard most of this reasoning. I got my wires
crossed between zeroing behavior and pollute_eofpage().
pollute_eofpage() updates the file only, so just blows up in simulation
mode and is clearly wrong. :) That makes things more simple, though I
think the plan below to disable it is the same...

Brian

> 1. Split out another bug fix patch to do size related updates (including
> zeroing) consistently during simulation.
> 
> 2. Update pollute_eofpage() in the next patch to skip out when testcalls
> <= simulatedopcount (with some commenting).
> 
> Let me know if you think any of that doesn't make sense.
> 
> > /me reads the second patch but doesn't quite get it. :/
> > 
> 
> The zeroing tests I was using were basically manual test sequences to do
> things like this:
> 
> 	xfs_io -fc "truncate 2k" -c "falloc -k 0 4k" ... -c "mwrite 0 4k" \
> 		-c "truncate 8k" <file>
> 
> ... which itentionally writes beyond EOF before a truncate up operation
> to test whether the zero range in the truncate path DTRT with a dirty
> folio over an unwritten block. In a nutshell, I'm just trying to
> genericize that sort of test a bit more by doing similar post-eof
> mwrites opportunistically in fsx in operations that should be expected
> to do similar zeroing in-kernel.
> 
> I.e., replace the "truncate 8k" above with any size extending operation
> that starts beyond EOF such that we should expect the range from
> 2k-<endofpage> to be zeroed. Does that explain things better?
> 
> > Are you doing this to mirror what the kernel does?  A comment here to
> > explain why we're doing this differently would help me.
> > 
> 
> Yeah, sort of... it's more like writing a canary value to a small range
> of the file but rather than expecting it to remain unmodified, we expect
> it to be zeroed by the upcoming operation. Therefore we don't write the
> garbage data to goodbuf, because goodbuf should contain zeroes and we
> want to detect a data mismatch on subsequent reads if the kernel didn't
> do the expected zeroing.
> 
> Brian
> 
> > --D
> > 
> > >  
> > > @@ -1263,17 +1271,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
> > >  	}
> > >  
> > >  	memset(good_buf + offset, '\0', length);
> > > -
> > > -	if (!keep_size && end_offset > file_size) {
> > > -		/*
> > > -		 * If there's a gap between the old file size and the offset of
> > > -		 * the zero range operation, fill the gap with zeroes.
> > > -		 */
> > > -		if (offset > file_size)
> > > -			memset(good_buf + file_size, '\0', offset - file_size);
> > > -
> > > -		file_size = end_offset;
> > > -	}
> > >  }
> > >  
> > >  #else
> > > @@ -1538,6 +1535,9 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
> > >  
> > >  	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
> > >  
> > > +	if (dest + length > file_size)
> > > +		update_file_size(dest, length);
> > > +
> > >  	if (testcalls <= simulatedopcount)
> > >  		return;
> > >  
> > > @@ -1556,10 +1556,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
> > >  	}
> > >  
> > >  	memcpy(good_buf + dest, good_buf + offset, length);
> > > -	if (dest > file_size)
> > > -		memset(good_buf + file_size, '\0', dest - file_size);
> > > -	if (dest + length > file_size)
> > > -		file_size = dest + length;
> > >  }
> > >  
> > >  #else
> > > @@ -1756,6 +1752,9 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> > >  
> > >  	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
> > >  
> > > +	if (dest + length > file_size)
> > > +		update_file_size(dest, length);
> > > +
> > >  	if (testcalls <= simulatedopcount)
> > >  		return;
> > >  
> > > @@ -1792,10 +1791,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> > >  	}
> > >  
> > >  	memcpy(good_buf + dest, good_buf + offset, length);
> > > -	if (dest > file_size)
> > > -		memset(good_buf + file_size, '\0', dest - file_size);
> > > -	if (dest + length > file_size)
> > > -		file_size = dest + length;
> > >  }
> > >  
> > >  #else
> > > @@ -1846,7 +1841,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
> > >  
> > >  	if (end_offset > file_size) {
> > >  		memset(good_buf + file_size, '\0', end_offset - file_size);
> > > -		file_size = end_offset;
> > > +		update_file_size(offset, length);
> > >  	}
> > >  
> > >  	if (testcalls <= simulatedopcount)
> > > -- 
> > > 2.45.0
> > > 
> > > 
> > 
> 
> 


